//go:build copilotsdk

// Package llm — Phase 2 STUB: official GitHub Copilot SDK transport.
//
// Excluded from the normal build (build tag "copilotsdk") so it does NOT pull
// the preview dependency github.com/github/copilot-sdk/go into go.mod or affect
// `go build ./...`. See docs/copilot-sdk-integration.md for the full design,
// prerequisites, and enabling steps.
//
// This is the skeleton for replacing the reverse-engineered direct-HTTP Copilot
// path (copilot_token.go) with GitHub's supported backend integration: the SDK
// manages the Copilot CLI, which owns the token exchange, token refresh,
// data-residency host routing, and model availability — the things that cause
// 502s on Enterprise when done by hand.
//
// TECHNICAL PREVIEW: the SDK is v0.1.x and its session/prompt API differs
// between releases. Pin a version and confirm every signature marked TODO
// against https://pkg.go.dev/github.com/github/copilot-sdk/go before relying on
// this file. It is intentionally not wired into the client yet.
package llm

import (
	"context"
	"fmt"

	copilot "github.com/github/copilot-sdk/go"
)

// copilotSDKClient wraps a started SDK client. One client manages the Copilot
// CLI process for its lifetime, so create it ONCE at startup and Close() it at
// shutdown — never per request.
type copilotSDKClient struct {
	c *copilot.Client
}

// newCopilotSDKClient starts the SDK client, which launches/connects to the
// Copilot CLI. Auth comes from COPILOT_GITHUB_TOKEN (service token) unless a
// per-request token is supplied at session creation. CLI path is COPILOT_CLI_PATH
// or "copilot". Supported tokens: gho_, ghu_, github_pat_ (classic ghp_ is not).
func newCopilotSDKClient(ctx context.Context) (*copilotSDKClient, error) {
	c := copilot.NewClient(nil) // TODO: pass a *copilot.ClientConfig to set CLIPath / token / log level.
	if err := c.Start(ctx); err != nil {
		return nil, fmt.Errorf("copilot-sdk: start client (is the `copilot` CLI installed and authenticated?): %w", err)
	}
	return &copilotSDKClient{c: c}, nil
}

// Close stops the SDK client and its managed CLI process.
func (s *copilotSDKClient) Close() {
	if s != nil && s.c != nil {
		s.c.Stop()
	}
}

// copilotSDKComplete runs one chat turn through the SDK and streams assistant
// text to onToken. This is the seam the client's chat loop would call for the
// "copilot" provider (behind a config flag) instead of the direct-HTTP path.
//
// TODO — the real work (see docs/copilot-sdk-integration.md):
//   - Map ai-dast-ing's []Message history onto the session's prompt/history.
//   - Map NATIVE TOOL CALLS both directions: the agent depends on OpenAI-shaped
//     tool calls, so translate to/from the SDK's tool/function-call representation.
//   - Surface token usage for cost accounting.
//   - Confirm streaming event types and the prompt call for the pinned version.
func copilotSDKComplete(ctx context.Context, cl *copilotSDKClient, model, prompt string, onToken func(string)) (string, error) {
	session, err := cl.c.CreateSession(ctx, &copilot.SessionConfig{
		Model: model,
		// Streaming: true, // TODO: confirm field/shape for streaming in the pinned SDK version.
	})
	if err != nil {
		return "", fmt.Errorf("copilot-sdk: create session: %w", err)
	}

	// TODO: send `prompt`, iterate the streamed events, call onToken(delta) for
	// each text chunk, and accumulate the full reply. Replace the stub below.
	_ = session
	_ = onToken
	return "", fmt.Errorf("copilot-sdk: copilotSDKComplete not implemented — see docs/copilot-sdk-integration.md")
}
