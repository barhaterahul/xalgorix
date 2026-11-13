# Copilot SDK integration (Phase 2 — design + stub)

Status: **not implemented.** This is the design for replacing the current
reverse-engineered direct-HTTP Copilot path with GitHub's **officially
supported** backend integration, for robustness on Copilot Business/Enterprise.

## Why

The current `copilot` provider (`internal/llm/copilot_token.go`) calls the
**undocumented** `https://api.github.com/copilot_internal/v2/token` exchange and
posts directly to `https://api.githubcopilot.com/chat/completions`. This works
for Copilot Free/Individual but is brittle on Enterprise:

- Data-residency (`ghe.com`) tenants route Copilot through a tenant host our
  direct call doesn't know about → **502 Bad Gateway**.
- GitHub can change/remove the internal endpoint at any time.

Phase 1 (shipped) adds `AIDASTING_COPILOT_API_URL` to point at a tenant host
explicitly, which fixes the host-routing class of 502. Phase 2 (this doc) moves
to the official SDK so GitHub's own client owns token exchange, refresh,
data-residency host routing, and model availability.

## Official architecture

GitHub's supported backend pattern (docs: *Copilot SDK → Set up → Backend
services*):

1. The **Copilot CLI** runs as a local server; the SDK launches/manages it
   (CLI path = `copilot` or `COPILOT_CLI_PATH`). It must be installed and the
   service token available.
2. Your Go process uses `github.com/github/copilot-sdk/go` (package `copilot`,
   Go 1.24+) to connect, create a session, and prompt.
3. Auth is a GitHub token via `COPILOT_GITHUB_TOKEN` (service token) or a
   per-request `gitHubToken`. Supported: `gho_`, `ghu_`, `github_pat_`
   (fine-grained). Classic `ghp_` is **not** supported.

Known API shape (v0.1.x, **technical preview — may break**):
```go
client := copilot.NewClient(nil)
if err := client.Start(ctx); err != nil { /* ... */ }
defer client.Stop()
session, err := client.CreateSession(ctx, &copilot.SessionConfig{ /* Model, streaming */ })
// send prompt; read streamed response
```

## The hard part

ai-dast-ing's LLM layer (`internal/llm/client.go`) is built around
**OpenAI-compatible HTTP**: it builds chat/completions requests, parses the
OpenAI streaming shape, and extracts **native tool calls** in that shape. The
Copilot SDK is a **session API**, not OpenAI HTTP — so this is a new transport,
not a new catalog entry. The agent's streaming + tool-calling must be mapped
onto the SDK session.

Two implementation routes:

- **Route A — native SDK transport (fully official, large).** Add a Copilot-SDK
  code path in the client that maps the agent's "messages → streamed tokens →
  tool calls" onto `CreateSession`/prompt. Biggest work, no extra process at
  runtime beyond the CLI the SDK manages.
- **Route B — local OpenAI bridge (near-zero app change, extra process).** Run
  `copilot --headless` plus a small adapter exposing OpenAI-compatible
  `/chat/completions`, and point the **Custom Provider** at it. ai-dast-ing
  stays unchanged; the bridge is separate glue (a community `copilot-api` proxy
  can stand in). Fastest to a working Enterprise setup.

## Prerequisites before coding Route A

1. Confirm the org policy allows **backend / server-to-server** Copilot (admin).
   Nothing in code bypasses this; without it even the official SDK fails.
2. Install the Copilot CLI and authenticate it; have a token that mints a
   session (verify with the Phase-0 curl / `TestCopilotLive`).
3. `go get github.com/github/copilot-sdk/go` and **pin a version** (preview API
   differs between v0.1.x releases).

## Enabling the stub

`internal/llm/copilot_sdk.go` is behind `//go:build copilotsdk`, so it is
excluded from the normal build and does not pull the preview dependency. To work
on it:

```bash
go get github.com/github/copilot-sdk/go@v0.1.22   # pin the version you target
go build -tags copilotsdk ./internal/llm/
go test  -tags copilotsdk ./internal/llm/ -run CopilotSDK
```

Then wire `copilotSDKComplete` into the client's chat loop for the `copilot`
provider (gated on a config/env flag) and map tool-calls + usage.

## References
- Copilot SDK backend services: https://docs.github.com/en/copilot/how-tos/copilot-sdk/setup/backend-services
- Copilot SDK auth: https://docs.github.com/en/copilot/how-tos/copilot-sdk/auth/authenticate
- Go SDK: https://pkg.go.dev/github.com/github/copilot-sdk/go
