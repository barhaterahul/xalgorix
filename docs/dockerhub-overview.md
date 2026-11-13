# AI-DAST-ING — AI Autonomous Penetration Testing

**Self-hosted AI pentester that finds, exploits, and verifies real vulnerabilities.**

Most scanners *detect*. AI-DAST-ING *proves* — an autonomous LLM agent works a full 22-phase methodology, then an independent verifier re-exploits every finding before it's reported, so you get proof with evidence, not a wall of maybes to triage.

This image is **batteries-included**: it's built on Kali Linux with hundreds of offensive-security tools preinstalled, and it keeps every package manager available so the agent can auto-install anything else it needs at runtime.

- 🧠 **An AI agent, not a template engine** — reasons about auth flows, business logic, IDOR/BOLA, and chained exploits signature scanners miss.
- ✅ **Exploit-verified findings** — a separate verifier reproduces each finding; inconclusive ones are flagged, never dressed up as confirmed.
- 🔒 **Self-hosted & private** — runs on your infrastructure with your own LLM key. No target data, keys, or findings leave your machine.
- 🧩 **Bring your own LLM** — OpenAI, Anthropic, DeepSeek, Gemini, Groq, Ollama, or MiniMax.
- 📄 **Audit-ready reports** — branded PDFs with CVSS scores, proof-of-concept, and remediation.

---

## Quick start

```bash
docker run --rm -p 9137:9137 \
  -e AIDASTING_LLM=openai/gpt-5.6 \
  -e AIDASTING_API_KEY=your_openai_api_key \
  -v ai-dast-ing-data:/data \
  barhaterahul/ai-dast-ing:latest
```

Then open **http://127.0.0.1:9137**.

For best autonomous scanning results, choose a current frontier model with strong reasoning and reliable tool calling. The example model can be replaced with any newer compatible provider model ID.

> Use AI-DAST-ING only against systems you own or are explicitly authorized to test.

---

## Reviewing GitHub pull requests (free, no install)

Prefer security review straight on your PRs? Install the **[AI-DAST-ING GitHub App](https://github.com/apps/ai-dast-ing/installations/new)** — it comments a security review on each pull request's diff (injection, broken auth/IDOR, SSRF, secrets, unsafe patterns), updates in place on new commits, and re-runs when you comment `@ai-dast-ing review`. No workflow file, API key, or account required. This container image is for the deeper, self-hosted exploit-verified pentest.

---

## What's inside

An extensive toolset ships preinstalled — `nmap`, `nuclei`, `httpx`, `subfinder`, `dnsx`, `naabu`, `katana`, `ffuf`, `gobuster`, `dalfox`, `feroxbuster`, `sqlmap`, `masscan`, `nikto`, `whatweb`, `hydra`, SecLists, and the broader Kali web/vulnerability/fuzzing/passwords metapackages — plus Chromium for browser-assisted DAST. The Go, Rust (cargo), Python (pipx/pip), and npm toolchains stay in the image, so the agent can install anything not baked in, on demand.

## Configuration

| Variable | Required | Description |
| --- | --- | --- |
| `AIDASTING_LLM` | ✅ | Model ID, usually with a provider prefix, e.g. `openai/gpt-5.6`. For best results use a current frontier model; MiniMax and local models remain supported. |
| `AIDASTING_API_KEY` | ✅ | API key for the configured LLM provider. |
| `AIDASTING_API_BASE` | — | Custom OpenAI-compatible base URL. |
| `AIDASTING_USERNAME` / `AIDASTING_PASSWORD` | — | Dashboard auth. **Required** before exposing the dashboard beyond localhost. |
| `AIDASTING_DATA_DIR` | — | Scan output / reports location. Defaults to `/data` (mount a volume). |

- **Port:** `9137` (dashboard + API). The container binds `0.0.0.0` internally; publish with `-p 9137:9137`.
- **Volume:** mount `/data` to persist scans and reports across restarts.

## Tags

| Tag | Meaning |
| --- | --- |
| `latest` | Most recent release. |
| `X.Y.Z` (e.g. `4.5.50`) | A specific, immutable release. |
| `X.Y` (e.g. `4.5`) | Latest patch of that minor line. |

**Platforms:** `linux/amd64` and `linux/arm64`. Docker automatically selects the native image for the host.

## Security notes

- The container runs as **root by design** — the engine only enables runtime tool auto-install for uid 0, and `apt`/`go`/`cargo` installs need system write access. Treat the container as a disposable, network-isolated scanning sandbox.
- **Never expose the dashboard publicly without `AIDASTING_USERNAME`/`AIDASTING_PASSWORD`.** The server refuses external binding without auth.
- No scan data, API keys, or findings leave the container unless you configure outbound integrations (Discord/Telegram/webhooks).

## Links

- **Source & docs:** https://github.com/ai-dast-ing/ai-dast-ing
- **Documentation:** https://docs.ai-dast-ing.com
- **Hosted (no install):** https://www.ai-dast-ing.com
- **One-line install (Linux or macOS, amd64/arm64):** `curl -sSL https://www.ai-dast-ing.com/install | bash`

Released under the Apache License 2.0.
