<div align="center">

<img src="assets/banner.png?v=4.6.133" alt="AI-DAST-ING — AI Autonomous Penetration Testing Platform" width="860" />

<br />

[![Go](https://img.shields.io/badge/Go-1.26+-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://go.dev)
[![License](https://img.shields.io/badge/License-Apache_2.0-10b981?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux_%7C_macOS-111111?style=for-the-badge&logo=linux&logoColor=white)](#-installation)
[![AI-DAST-ING Cloud](https://img.shields.io/badge/Cloud-no_install-C51C39?style=for-the-badge)](https://www.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=hero_badge)
[![GitHub stars](https://img.shields.io/github/stars/ai-dast-ing/ai-dast-ing?style=for-the-badge&logo=github&color=yellow)](https://github.com/ai-dast-ing/ai-dast-ing/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/ai-dast-ing/ai-dast-ing?style=for-the-badge&logo=github&color=blue)](https://github.com/ai-dast-ing/ai-dast-ing/network/members)
[![GitHub release](https://img.shields.io/github/v/release/ai-dast-ing/ai-dast-ing?style=for-the-badge&logo=github&color=green)](https://github.com/ai-dast-ing/ai-dast-ing/releases)

</div>

<h1 align="center">AI-DAST-ING — Open-source AI pentester that <em>proves</em> vulnerabilities</h1>

<p align="center">
  <strong>Most scanners detect. AI-DAST-ING proves.</strong> An autonomous LLM agent works a full pentest methodology, then an <strong>independent verifier re-exploits every finding</strong> before it's reported — so you get proof, not a pile of maybes to triage. Self-hosted, private, and bring-your-own-LLM. Built in Go + TypeScript.
</p>

<p align="center">
  <a href="#-quick-start">🚀 Quick Start</a> ·
  <a href="#-why-ai-dast-ing">💡 Why AI-DAST-ING</a> ·
  <a href="#-features">✨ Features</a> ·
  <a href="#-use-cases">🎯 Use Cases</a> ·
  <a href="#self-host-or-cloud">☁️ Self-host or Cloud</a> ·
  <a href="https://docs.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_docs&utm_content=hero_nav">📖 Docs</a> ·
  <a href="https://github.com/ai-dast-ing/ai-dast-ing/discussions">💬 Discussions</a>
</p>

| 🖥️ **Self-host** — this repo | ☁️ **[AI-DAST-ING Cloud](https://www.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=two_ways_title)** — nothing to install |
| --- | --- |
| Free and Apache-2.0. Runs on your machine with your own LLM key, or fully local with Ollama. Findings and reports stay on your infrastructure. | The same exploit-verified engine in your browser. Model, out-of-band callbacks and scheduling are managed for you. Packs from $10; credits never expire. |
| [**Install in two commands ↓**](#-quick-start) | [**Compare self-hosted vs Cloud →**](https://www.ai-dast-ing.com/hosted-vs-self-hosted?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=two_ways_compare) |

<p align="center">🤖 Only need PR reviews? The <a href="https://github.com/apps/ai-dast-ing">free AI-DAST-ING GitHub App</a> comments a security review on every pull request — no account, no API key.</p>

---

## 📸 Screenshots

**🖥️ Self-hosted dashboard** — runs locally on `127.0.0.1:9137`

| Overview dashboard                                      | Scan detail                                      | Findings                                      |
| ------------------------------------------------------- | ------------------------------------------------ | --------------------------------------------- |
| ![AI-DAST-ING overview dashboard](assets/screenshot-1.png) | ![AI-DAST-ING scan detail](assets/screenshot-2.png) | ![AI-DAST-ING findings](assets/screenshot-3.png) |

**☁️ AI-DAST-ING Cloud dashboard** — the managed version at [www.ai-dast-ing.com](https://www.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=screenshot_caption)

<a href="https://www.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=screenshot"><img src="assets/SaaS-dashboard.png?v=4.5.154" alt="AI-DAST-ING Cloud dashboard showing security score, vulnerability trends, remediation metrics, and open issues by category" width="860" /></a>

---

---

## 🤝 Sponsors

AI-DAST-ING is supported by proxy-infrastructure partners — handy for checking how your own apps behave across regions. Proxy-Seller speaks **HTTP(S) and SOCKS5**, the protocols AI-DAST-ING uses.

<table>
  <tr>
    <td align="center" valign="middle" width="50%">
      <a href="mailto:partners@ai-dast-ing.com?subject=README%20sponsorship"><img src="assets/sponsor_placeholder.svg" alt="Your logo here: this sponsor spot is open" height="132" /></a>
    </td>
    <td align="center" valign="middle" width="50%">
      <a href="https://proxy-seller.com/?partner=11571212D46044C9"><img src="assets/proxyseller_ai-dast-ing.jpg" alt="Proxy-Seller" height="132" /></a>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top">
      <b><a href="mailto:partners@ai-dast-ing.com?subject=README%20sponsorship">Your brand here</a></b><br/>
      <sub>This sponsor spot is open<br/>Email <a href="mailto:partners@ai-dast-ing.com?subject=README%20sponsorship">partners@ai-dast-ing.com</a> to claim it</sub>
    </td>
    <td align="center" valign="top">
      <b><a href="https://proxy-seller.com/?partner=11571212D46044C9">Proxy-Seller</a></b><br/>
      <sub>47M+ residential IPs · 220+ locations · residential, mobile, ISP &amp; datacenter<br/>AI-DAST-ING users get <b>15% off</b> with <code>AI-DAST-ING</code></sub>
    </td>
  </tr>
</table>

---

## 🚀 Quick Start

**Install (one line):**

```bash
curl -sSL https://www.ai-dast-ing.com/install | bash
```

This downloads the prebuilt binary for your platform (Linux or macOS, amd64/arm64) from the latest release.

**Or install with Go 1.26 or newer:**

```bash
go install github.com/barhaterahul/ai-dast-ing/v4/cmd/ai-dast-ing@latest
```

Ensure `$(go env GOPATH)/bin` (or your `GOBIN`) is on your `PATH` before running `ai-dast-ing`.

Then run the interactive setup wizard:

```bash
ai-dast-ing --setup
```

Choose your provider, confirm a model, and enter the API key when prompted. For best results, use a current frontier model with strong reasoning, long-context performance, and reliable tool calling—such as the latest capable GPT, Claude, or Gemini model available to you. Smaller or local models remain supported, but may require more supervision during long autonomous scans. AI-DAST-ING stores the key privately in `~/.ai-dast-ing.env` (mode `0600`) and can launch the dashboard for you. Local Ollama needs no API key.

If you choose not to launch immediately, start later with `ai-dast-ing --web` and open `http://127.0.0.1:9137`. You can change providers or advanced options at any time under **Settings → LLM**, or rerun `ai-dast-ing --setup`.

**Or run with Docker — batteries included, no toolchain needed:**

```bash
docker run --rm -p 9137:9137 \
  --privileged \
  -v ai-dast-ing-data:/data \
  barhaterahul/ai-dast-ing:latest
```

`--privileged` gives the toolset the same host-like access it has when run natively as root. Docker's default sandbox drops capabilities (like `NET_ADMIN`) and applies a seccomp filter, which breaks low-level tools (iptables/route changes, ARP-spoof/MITM, tun/tap VPNs, ptrace-based debuggers, masscan interface tuning). Since an image can't grant itself these, they must be set at run time. The container is a disposable, network-isolated scanning sandbox running as root — privileged is the intended posture; never expose the dashboard publicly without auth. Prefer least-privilege? Swap `--privileged` for `--cap-add=NET_ADMIN --cap-add=NET_RAW --cap-add=SYS_PTRACE --security-opt seccomp=unconfined`.

Open `http://localhost:9137`. You **don't need an LLM key to start** — the dashboard launches without one; set the model + API key under **Settings → LLM** (it persists to the `/data` volume). If you don't pass `AIDASTING_USERNAME`/`AIDASTING_PASSWORD`, a random admin password is generated and printed to the container logs on first run.

**Machine-to-machine API access** — give automation (your own backend, CI, scripts) a dedicated `Authorization: Bearer` token instead of dashboard credentials: set `AIDASTING_API_TOKEN` (or `AIDASTING_API_TOKENS` for a comma-separated rotation set). Machine tokens authorize `/api/*` routes and the scan-event WebSocket only — never the dashboard UI or operator-only settings routes — never create browser sessions, never interact with the dashboard login rate limiter, and are matched against stored SHA-256 digests with constant-time comparison. The human dashboard login (`AIDASTING_USERNAME` + `AIDASTING_PASSWORD_HASH`) keeps working unchanged alongside them.

**Easiest — Docker Compose** (maps the port + a persistent volume for you):

```bash
curl -sSLO https://raw.githubusercontent.com/ai-dast-ing/ai-dast-ing/main/docker-compose.yml
docker compose up -d
docker compose logs -f   # shows the generated admin password on first start
```

The image ships an extensive offensive-security toolset preinstalled (nmap, nuclei, httpx, subfinder, katana, ffuf, gobuster, sqlmap, masscan, dalfox, feroxbuster, and more) **and** keeps every package manager (apt, go, cargo, pipx, npm) available so the agent can still auto-install anything missing at runtime. It runs as root inside the container by design — treat the container as a disposable, network-isolated scanning sandbox and never expose the dashboard without auth. Images are published for both amd64 and arm64.

**Or build from source** (needs Go 1.26+ and Node.js):

```bash
git clone https://github.com/ai-dast-ing/ai-dast-ing.git
cd ai-dast-ing
make build
sudo install -m 755 build/ai-dast-ing /usr/local/bin/ai-dast-ing
```

> [!TIP]
> **Rather skip the setup?** [AI-DAST-ING Cloud](https://www.ai-dast-ing.com/signup?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=quickstart_tip) runs the same exploit-verified engine in your browser — no install, no LLM key, no token bill. Packs from $10, no subscription; credits never expire.

### 🤖 Review pull requests automatically — free GitHub App

Want a security review on every pull request with zero setup? Install the **[AI-DAST-ING GitHub App](https://github.com/apps/ai-dast-ing)**. It reads each PR's diff and comments a security review — injection, broken auth/IDOR, SSRF, secrets, unsafe patterns — right on the pull request. Updates in place on new commits, and you can comment **`@ai-dast-ing review`** to re-run on demand. No workflow file, no API key, no account — and it's free.

<div align="center">

[**➕ Add AI-DAST-ING to GitHub →**](https://github.com/apps/ai-dast-ing/installations/new)

</div>

Need merge gating or a full exploit-verified pentest of the running app? Start a [Cloud scan from your CI](https://www.ai-dast-ing.com/docs/api?utm_source=github&utm_medium=readme&utm_campaign=gh_app_to_cloud&utm_content=app_block_ci) with the REST API and gate on verified findings at the severity you choose.

> [!IMPORTANT]
> Use AI-DAST-ING only on systems you own or have explicit permission to test.

## 📚 Contents

| | | |
| --- | --- | --- |
| 📸 [Screenshots](#-screenshots) | 🔩 [Configuration](#-configuration) | 🧾 [Environment Variables](#-environment-variables) |
| 🚀 [Quick Start](#-quick-start) | 🆙 [Upgrading](#-upgrading-from-previous-versions) | 🔤 [Provider Prefixes](#-provider-prefixes) |
| 🔎 [Overview](#-overview) | 🏃 [Running](#-running) | 💻 [CLI Reference](#-cli-reference) |
| 💡 [Why AI-DAST-ING](#-why-ai-dast-ing) | 🧰 [Service Mode](#-service-mode) | 📡 [API Summary](#-api-summary) |
| 🎯 [Use Cases](#-use-cases) | 🔁 [Web UI Workflow](#-web-ui-workflow) | 💾 [Data Storage](#-data-storage) |
| ✨ [Features](#-features) | 🔀 [Scan Modes](#-scan-modes) | 🧪 [Development](#-development) |
| 📥 [Installation](#-installation) | 📂 [Scan Your Code](#-scan-your-code-no-target-needed) | 🚨 [Safety Notes](#-safety-notes) |
| 🧭 [Methodology](#-methodology) | 📄 [Reports](#-reports) | 📜 [License](#-license) |
| 🔧 [Settings](#-settings) | 🔗 [Links](#-links) | 🤝 [Sponsors](#-sponsors) |

## 🔎 Overview

AI-DAST-ING is a self-hosted AI penetration testing platform for authorized security testing, vulnerability assessment, and bug bounty workflows. It combines an LLM-driven autonomous agent, browser automation, terminal tooling, a comprehensive 22-phase testing methodology, live WebSocket telemetry, finding management with CVSS scoring, branded PDF report generation, and integrations for AgentMail, Discord, and Telegram.

Unlike cloud-only DAST scanners, AI-DAST-ING runs entirely on your machine. You bring your own LLM provider (OpenAI, Anthropic, DeepSeek, Gemini, Groq, Ollama, MiniMax) and control the model, reasoning effort, rate limits, and proxy configuration. Nothing is sent to AI-DAST-ING: scan context goes only to the LLM provider you configure (or stays local with Ollama), and blind-vulnerability callbacks use public Interactsh servers unless you set `AIDASTING_INTERACTSH_SERVER` to your own.

The default experience is the Web UI. From one local dashboard you can start scans, monitor active runs, inspect findings, configure model/provider settings, manage environment variables, generate branded PDF reports, and delete or resume historical scans.

## 💡 Why AI-DAST-ING

Most scanners **detect**. AI-DAST-ING **proves**. An autonomous agent works through a 22-phase methodology, then an independent verifier re-tests every candidate finding before it is reported — so you get exploit-verified results with evidence, not a wall of "maybes" to triage.

- 🧠 **An AI agent, not a template engine** — reasons about auth flows, business logic, IDOR/BOLA, and chained exploits that signature scanners miss.
- ✅ **Exploit-verified findings** — a separate verifier independently reproduces each finding; inconclusive ones are flagged for review, never dressed up as confirmed.
- 🔒 **Self-hosted and private** — runs on your machine with your own LLM key; nothing is sent to AI-DAST-ING, and with a local model plus your own OOB server, nothing leaves your network except traffic to the target.
- 🧩 **Bring your own LLM** — OpenAI, Anthropic, DeepSeek, Gemini, Groq, Ollama, or MiniMax — or any OpenAI-compatible gateway like [LiteLLM](#-litellm--openai-compatible-gateways-github-copilot-claude-opus-codex-openrouter-azure-local-models) (GitHub Copilot, Codex, OpenRouter, Azure). You control model, reasoning effort, and cost.
- 📄 **Audit-ready reports** — branded PDFs with CVSS scores, proof-of-concept, and remediation.

### 📊 How it compares

|                                              | **AI-DAST-ING**             | Template scanners (e.g. Nuclei) | Crawling scanners (e.g. OWASP ZAP) | Commercial DAST        |
| -------------------------------------------- | ------------------------ | ------------------------------- | ---------------------------------- | ---------------------- |
| Approach                                     | Autonomous AI agent      | Signatures / templates          | Spider + active rules              | Signatures + heuristics |
| Business logic / IDOR / auth-bypass coverage | ✅                       | Limited                         | Limited                            | Partial                |
| Exploit-verified (proves impact)             | ✅ independent verifier  | ❌                              | ❌                                 | Partial                |
| False-positive load                          | Low — re-exploited first | Template-dependent              | High                               | Medium                 |
| Self-hosted / data stays local               | ✅                       | ✅                              | ✅                                 | Usually cloud          |
| Bring-your-own LLM                           | ✅                       | —                               | —                                  | ❌                     |
| Branded PDF reports                          | ✅                       | ❌                              | Basic                              | ✅                     |
| Cost                                         | Open source + your LLM   | Free                            | Free                               | $$$                    |

> Directional comparison — Nuclei and ZAP are excellent at what they do. AI-DAST-ING adds the reasoning-heavy discovery and exploit-verification layer on top.

<a name="self-host-or-cloud"></a>

### ☁️ Self-hosted or AI-DAST-ING Cloud?

AI-DAST-ING is free and open source — self-host it forever, no strings attached. [AI-DAST-ING Cloud](https://www.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=compare_intro) runs the **same** exploit-verified engine for people who would rather not manage LLM keys and token bills, a ~6–8 GB privileged toolbox container, or their own callback infrastructure. Both are first-class — pick what fits.

|                                    | **Self-hosted** (this repo)                                  | **[AI-DAST-ING Cloud](https://www.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=compare_table_header)** |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------ |
| Price to start                     | Free engine, Apache-2.0                                      | Packs from $10 (no subscription) or plans from $49/mo — [pricing](https://www.ai-dast-ing.com/pricing?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=compare_table_price) |
| LLM                                | Bring your own key — or run fully local with Ollama          | Included — no key, no token bill                       |
| Cost per scan                      | Your LLM tokens — varies with target size and model          | 1 credit per target or live host (very long scans: up to 3) — [how credits work](https://www.ai-dast-ing.com/pricing?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=compare_table_credits) |
| Setup & ops                        | One-line installer, or Docker (~6–8 GB image, `--privileged`) | Nothing to run — start from the browser               |
| Blind-vuln callbacks (OOB)         | Public Interactsh by default, or your own OOB server         | Managed DNS/HTTP/SMTP listeners                        |
| Scheduling & alerts                | Built-in scheduler + Discord/Telegram, on your host          | Managed daily schedules + Slack/Discord/webhooks (Pro/Max) |
| Sharing                            | Single-operator dashboard, PDF reports                       | Share links (password-protected on Pro/Max); private deployments via [sales](mailto:sales@ai-dast-ing.com) |
| Updates                            | Binary auto-updates from GitHub Releases; Docker: pull a new tag | Engine updates managed for you                     |
| Data residency / offline           | ✅ stays on your infra · air-gap OK with local models         | Runs on our infra (DPA available)                      |

**Self-host if** data must stay on your network, you want full control, or you'll run offline/air-gapped — that's exactly what it's for. **Use Cloud if** you'd rather skip the API keys, infrastructure and surprise token bills, and pay per target instead of per token.

<div align="center">

[**☁️ Start a Cloud scan →**](https://www.ai-dast-ing.com/signup?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=cta_signup) &nbsp;·&nbsp; [**💳 See pricing**](https://www.ai-dast-ing.com/pricing?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=cta_pricing) &nbsp;·&nbsp; [**⚖️ Full comparison & cost calculator**](https://www.ai-dast-ing.com/hosted-vs-self-hosted?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=cta_compare)

</div>

If AI-DAST-ING saves you a triage cycle, please **[⭐ star the repo](https://github.com/ai-dast-ing/ai-dast-ing)** — it genuinely helps others find it.

## 🎯 Use Cases

| Use Case | How AI-DAST-ING helps |
| -------- | ------------------ |
| **Penetration testing** | Run a full 22-phase methodology against authorized targets. The AI agent handles reconnaissance, vulnerability discovery, injection testing, SSRF, IDOR, auth bypass, race conditions, and more — then verifies findings before reporting. |
| **Bug bounty hunting** | Point AI-DAST-ING at an in-scope target and let the agent enumerate the attack surface, test for common vulnerability classes, and surface verified findings with CVSS scores and proof-of-concept evidence. |
| **Red team operations** | Use wildcard and multi-target scan modes to map an organization's external attack surface. Browser-assisted DAST handles auth flows, forms, and runtime behavior that static scanners miss. |
| **Security research** | The novel-vulnerability-discovery phase pushes the agent beyond known template matching. Bring your own LLM (OpenAI, Anthropic, DeepSeek, Gemini, Ollama, MiniMax) to control reasoning depth and cost. |
| **Continuous security testing** | Run as a system service with `ai-dast-ing --start`. Scan on a schedule, stream findings to Discord or Telegram, and generate branded PDF reports for stakeholders. |
| **DAST automation** | Browser-driven testing for web applications — auth flows, forms, JavaScript-rendered content, and runtime behavior. Integrates with Caido for proxy traffic inspection. |

## ✨ Features

| Area           | Capabilities                                                                                                                |
| -------------- | --------------------------------------------------------------------------------------------------------------------------- |
| 📊 Dashboard      | Local Web UI on `127.0.0.1:9137` by default, scan management, live status, bulk scan actions, and historical scan recovery. |
| 🔍 Scanning       | Single target, DAST, wildcard, and multi-target flows with selectable methodology phases.                                   |
| 📡 Live telemetry | Tool calls, agent messages, findings, errors, HTTP activity, and LLM activity over WebSockets.                              |
| 🐞 Findings       | Scan detail pages, severity filters, CVSS details, finding index, and verified finding workflows.                           |
| 📄 Reporting      | Branded PDF reports with target/company name, uploaded logo, report list, open/download/delete actions.                     |
| 🔔 Integrations   | AgentMail test inboxes, verification emails, OTP flows, email triage events, Discord and Telegram notifications.            |
| ⚙️ Configuration  | Dashboard settings for LLM, AgentMail, Discord, Telegram, proxy, runtime, browser, auth, rate limits, and resources.       |
| 🛡️ Runtime safety | Resource-aware instance limits and loopback-only binding unless external access is explicitly configured with auth.         |

## 📥 Installation

Use a prebuilt binary, Go, or a container.

### ⚡ One-line install (prebuilt binary)

```bash
curl -sSL https://www.ai-dast-ing.com/install | bash
```

Downloads the latest release binary for your platform (Linux or macOS, `amd64`/`arm64`) and installs it to `/usr/local/bin` (or `~/.local/bin` without sudo). Override with `AIDASTING_INSTALL_DIR` or pin a version with `AIDASTING_VERSION=vX.Y.Z`.

Complete first-time configuration interactively—no manual environment-file editing required:

```bash
ai-dast-ing --setup
```

The wizard preserves existing settings when rerun, hides API-key input in a terminal, and optionally launches the Web UI when finished.

### 📦 Install with Go

With Go 1.26 or newer:

```bash
go install github.com/barhaterahul/ai-dast-ing/v4/cmd/ai-dast-ing@latest
```

Go installs the binary to `GOBIN`, or to `$(go env GOPATH)/bin` when `GOBIN` is unset. Add that directory to your `PATH`, then run `ai-dast-ing --setup`.

### 🐳 Docker

```bash
docker run --rm -p 9137:9137 \
  --privileged \
  -e AIDASTING_LLM=openai/gpt-5.6 \
  -e AIDASTING_API_KEY=your_openai_api_key \
  -v ai-dast-ing-data:/data \
  ghcr.io/barhaterahul/ai-dast-ing:latest
```

`--privileged` (or the narrower `--cap-add=NET_ADMIN --cap-add=NET_RAW --cap-add=SYS_PTRACE --security-opt seccomp=unconfined`) gives the toolset host-like access. Docker's default sandbox drops capabilities and filters syscalls, which breaks low-level tooling (iptables/route/interface changes, ARP-spoof/MITM, tun/tap VPNs, ptrace-based debuggers). An image can't grant these to itself — they're a run-time decision — so pass the flag, or use the provided `docker-compose.yml`, which sets it for you.

The image is **batteries-included**: an extensive offensive-security toolset is preinstalled (nmap, nuclei, httpx, subfinder, dnsx, naabu, katana, ffuf, gobuster, dalfox, feroxbuster, sqlmap, masscan, nikto, whatweb, hydra, and more), plus Chromium for browser-assisted DAST. It also keeps the full package-manager set (apt, go, cargo, pipx, npm) available, so the agent auto-installs anything missing at runtime. Scan data persists to the `/data` volume, and the server binds `0.0.0.0` inside the container — set `AIDASTING_USERNAME`/`AIDASTING_PASSWORD` before exposing it beyond localhost.

The container runs as root by design (the engine only enables runtime auto-install for uid 0, and apt/go/cargo installs need system write access). Treat it as a disposable, network-isolated scanning sandbox. The same tags publish a multi-platform manifest for `linux/amd64` and `linux/arm64`, so Docker selects the native image automatically.

On first run, if you don't set dashboard auth the container **generates a random admin password and prints it to the logs** (the image binds `0.0.0.0`, which the engine won't do without auth). Set `AIDASTING_USERNAME` + `AIDASTING_PASSWORD` (or `AIDASTING_PASSWORD_HASH`) to use your own. The binary never self-updates inside the container (`AIDASTING_NO_AUTO_UPDATE=1`) — pull a new image tag to upgrade. The **nuclei** engine and its vuln templates are refreshed to the latest on every image build (the release CI and `redeploy.sh` force this); pass `--build-arg NUCLEI_VERSION=vX.Y.Z` to pin the engine, or `NUCLEI_REFRESH=0 ./redeploy.sh` to reuse Docker's cache.

### ☸️ Kubernetes (Helm)

A Helm chart is included in the repository at [`deploy/chart`](deploy/chart). There is no hosted chart repository, so install from a git checkout:

```bash
git clone https://github.com/ai-dast-ing/ai-dast-ing.git
cd ai-dast-ing
helm install ai-dast-ing deploy/chart \
  --namespace ai-dast-ing --create-namespace \
  --set auth.username=admin \
  --set auth.password=change-me \
  --set env.secret.AIDASTING_LLM=openai/gpt-5.6 \
  --set env.secret.AIDASTING_API_KEY=your_openai_api_key
```

- The dashboard listens on port `9137`. Expose it with `ingress.enabled` (Ingress controller) or `httproute.enabled` (Gateway API) — never without dashboard auth.
- Scan data and persisted dashboard settings live on a PVC mounted at `/data` (see `persistence` in `values.yaml`). Settings changed in the dashboard's Settings UI are written to `/data/.ai-dast-ing.env` and take precedence over chart-provided env vars on restart.
- Any `AIDASTING_*` variable can be passed through `env.raw`, `env.config`, or `env.secret`. Dashboard credentials go in `auth`, or point `auth.existingSecret` at a Secret containing `AIDASTING_USERNAME`/`AIDASTING_PASSWORD`.
- The bundled toolset expects the same elevated permissions as the Docker run (`NET_ADMIN`, `NET_RAW`, `SYS_PTRACE`, seccomp `Unconfined`) — see the `securityContext` examples in `values.yaml`.

### 📋 Requirements (build from source)

| Requirement    | Notes                                                        |
| -------------- | ------------------------------------------------------------ |
| OS             | Linux or macOS (`amd64`/`arm64`).                            |
| Go             | `1.26` or newer.                                             |
| Node.js + npm  | Required when building the bundled React Web UI from source. |
| Security tools | Installed on demand only when auto-install is enabled.       |

Check your Go version:

```bash
go version
```

### 🔨 Build From Source

```bash
git clone https://github.com/ai-dast-ing/ai-dast-ing.git
cd ai-dast-ing
make build
sudo install -m 755 build/ai-dast-ing /usr/local/bin/ai-dast-ing
```

`make build` builds the React Web UI into `internal/web/static`, then builds the Go binary.

## 🔩 Configuration

AI-DAST-ING loads configuration in this order. Later sources override earlier ones.

| Order | Source                                                         |
| ----- | -------------------------------------------------------------- |
| 1     | `/etc/ai-dast-ing.env`                                            |
| 2     | `/home/<sudo-user>/.ai-dast-ing.env` when launched through `sudo` |
| 3     | `~/.ai-dast-ing.env`                                              |
| 4     | Environment variables already present in the process           |

Create the local environment file:

```bash
nano ~/.ai-dast-ing.env
```

### 🧩 Minimal Config

For the strongest autonomous scanning results, select a current frontier model. The model ID below is a concrete example; newer compatible model IDs can be entered without waiting for a AI-DAST-ING release.

```bash
AIDASTING_LLM=openai/gpt-5.6
AIDASTING_API_KEY=your_openai_api_key
```

### 🔌 Provider Examples

OpenAI:

```bash
AIDASTING_LLM=openai/gpt-5.6
AIDASTING_API_KEY=sk-...
```

Custom OpenAI-compatible provider:

```bash
AIDASTING_LLM=custom/security-model
AIDASTING_API_BASE=https://your-provider.example/v1
AIDASTING_API_KEY=your_provider_api_key
```

#### 🌉 LiteLLM / OpenAI-compatible gateways (GitHub Copilot, Claude Opus, Codex, OpenRouter, Azure, local models)

Because `AIDASTING_API_BASE` accepts any OpenAI-compatible `/v1/chat/completions` endpoint,
AI-DAST-ING works with a [LiteLLM](https://docs.litellm.ai/) proxy out of the box — no
AI-DAST-ING-side changes needed. LiteLLM handles the upstream provider auth (Copilot device
login, Azure keys, OpenRouter, Ollama, etc.); AI-DAST-ING just talks OpenAI to the gateway.

Run LiteLLM (example `config.yaml`):

```yaml
model_list:
  - model_name: claude-opus-5
    litellm_params:
      model: github_copilot/claude-opus-5   # or openrouter/…, azure/…, ollama/…
general_settings:
  master_key: sk-local-litellm-key
```

Point AI-DAST-ING at it — use the `custom/` prefix so the model name is sent verbatim and the
OpenAI chat-completions protocol is used:

```bash
AIDASTING_LLM=custom/claude-opus-5            # the LiteLLM model_name
AIDASTING_API_BASE=http://localhost:4000/v1     # your LiteLLM proxy
AIDASTING_API_KEY=sk-local-litellm-key          # LiteLLM master_key / virtual key
```

The same pattern covers GitHub Copilot Business/CLI, Claude Opus, Codex-style models,
OpenRouter, Azure OpenAI, and local Ollama models — anything LiteLLM can route. Keep the
`custom/` (or `openai/`) prefix and a non-Anthropic/Gemini `AIDASTING_API_BASE` so AI-DAST-ING
uses the standard OpenAI request shape that LiteLLM expects.

### 🔔 Optional Integrations

```bash
GEMINI_API_KEY=AIza...
AGENTMAIL_POD=am_us_pod_47
AGENTMAIL_API_KEY=ak_...
AIDASTING_DISCORD_WEBHOOK=https://discord.com/api/webhooks/...
AIDASTING_DISCORD_MIN_SEVERITY=high
```

### 🔐 Dashboard Authentication

```bash
AIDASTING_USERNAME=admin
AIDASTING_PASSWORD=change-this-password
```

> [!TIP]
> Prefer `AIDASTING_PASSWORD_HASH` for production deployments.

## 🆙 Upgrading from previous versions

This release ships a stability and workspace-isolation pass with one breaking change and a few new knobs worth knowing about.

### 💥 Breaking change: default workspace moved to `~/.ai-dast-ing/data/`

Scan output, notes, schedules, and other generated artefacts now live under `~/.ai-dast-ing/data/` instead of `$CWD` (the directory the binary was launched from).

To retain the previous behavior, point `AIDASTING_DATA_DIR` at your current working directory:

```bash
export AIDASTING_DATA_DIR=$(pwd)
```

A `[MIGRATION]` warning is emitted at startup when legacy markers (`notes.json`, `_schedules/`, `vulnerabilities.json`, or `YYYY-MM-DD/scan-*` directories) are detected in `$CWD` and `AIDASTING_DATA_DIR` is unset. AI-DAST-ING never reads, copies, or deletes those legacy files automatically; the warning is informational and only fires once per process.

### 🆕 New environment variable

| Variable                     | Default                       | Description                                                                                              |
| ---------------------------- | ----------------------------- | -------------------------------------------------------------------------------------------------------- |
| `AIDASTING_LLM_MAX_INFLIGHT`  | `4 × EffectiveMaxInstances`   | Caps simultaneous outbound LLM calls across all running scans. Minimum `1`. Cancelled waiters do not consume a slot. |

### 🩺 New health endpoint counters

`GET /api/status` now exposes:

| Field                 | Meaning                                                                              |
| --------------------- | ------------------------------------------------------------------------------------ |
| `panics_recovered`    | Goroutine, HTTP handler, and tool panics that were recovered without crashing.       |
| `path_rejections`     | Filesystem writes refused by Path_Policy (outside `data_dir` / `~/.ai-dast-ing/` / `/tmp`). |
| `watchdog_kills`      | Subprocesses terminated by the per-tool hard-timeout watchdog.                       |
| `admission_refusals`  | Scan admission requests denied due to the concurrency ceiling.                       |
| `llm_inflight_cap`    | Effective `AIDASTING_LLM_MAX_INFLIGHT` value for this process.                        |
| `data_dir`            | Resolved Data_Dir in use.                                                            |
| `allow_list`          | Filesystem roots accepted by Path_Policy.                                            |

## 🏃 Running

### 🪟 Web UI

```bash
ai-dast-ing --web
```

Open:

```text
http://127.0.0.1:9137
```

Use a different port:

```bash
ai-dast-ing --web --port 8080
```

### 🌐 External Access

Bind to another interface only after enabling dashboard authentication:

```bash
AIDASTING_USERNAME=admin AIDASTING_PASSWORD=change-this ai-dast-ing --web --bind 0.0.0.0
```

> [!WARNING]
> The server refuses external binding without dashboard authentication.

### 🏹 CLI Scan

```bash
ai-dast-ing --target https://example.com
```

With custom instructions:

```bash
ai-dast-ing --target https://app.example.com --instruction "Focus on SQL injection, IDOR, and auth bypass. Avoid destructive tests."
```

## 🧰 Service Mode

Install and start as a system service:

```bash
sudo ai-dast-ing --start
```

Manage the service:

```bash
sudo ai-dast-ing --restart
sudo ai-dast-ing --stop
sudo ai-dast-ing --uninstall
```

View logs:

```bash
journalctl -u ai-dast-ing -f
```

For quiet discovery or a paused scan, see [diagnosing scan waits](docs/SCAN_WAITS.md).

### 🌍 Remote Service Access

Expose the service to remote browsers only after enabling dashboard auth:

```bash
sudo tee -a /root/.ai-dast-ing.env >/dev/null <<'EOF'
AIDASTING_BIND=0.0.0.0
AIDASTING_USERNAME=admin
AIDASTING_PASSWORD=change-this
EOF

sudo ai-dast-ing --restart
```

Then open `http://<server-ip>:9137`.

If the process is listening but the page still does not load remotely, allow TCP port `9137` in the server firewall or cloud security group.

#### 🏠 Scanning local/internal targets

By default AI-DAST-ING refuses to scan loopback, `localhost`, private-range, or
its own interface addresses — they're the machine AI-DAST-ING runs on, not a
target. On a **self-hosted, single-tenant** box you can opt in to scan a
locally-hosted demo/staging app:

```bash
echo 'AIDASTING_ALLOW_LOCAL_TARGETS=true' | sudo tee -a /root/.ai-dast-ing.env
sudo ai-dast-ing --restart
```

The dashboard's own listener is **always** protected, even with this enabled.

> **⚠️ Shared / multi-tenant / hosted deployments: keep this OFF.** Enabling it
> would let a user's scan reach the operator's own machine and internal network.
> It is off by default, so no action is needed to stay safe — do not set
> `AIDASTING_ALLOW_LOCAL_TARGETS` (or pin `AIDASTING_ALLOW_LOCAL_TARGETS=false`),
> and don't expose the engine's Settings page to untrusted users.

## 🔁 Web UI Workflow

1. Open the dashboard at `http://127.0.0.1:9137`.
2. Go to Settings and confirm the LLM provider, API key, rate limits, and optional integrations.
3. Create a scan from New Scan.
4. Choose a scan mode.
5. Select methodology phases when you want a focused run.
6. Set severity filters when only certain severities should be reported live. The filter affects the real-time dashboard feed and notifications only; the PDF report and `/api/findings` always include every vulnerability the agent discovered.
7. Add company name and upload a logo for branded reports.
8. Monitor progress from Overview, Scan Detail, or Live Feed.
9. Open finding details, download reports, or manage historical scans from Scans and Reports.

## 🔀 Scan Modes

| Mode             | Best for                                                                        |
| ---------------- | ------------------------------------------------------------------------------- |
| 🎯 Single target    | Testing one known URL or host.                                                  |
| 🌐 Wildcard / multi | Enumerating related targets and scanning the discovered attack surface.         |
| 🧭 DAST             | Browser-assisted testing for web apps, auth flows, forms, and runtime behavior. |

## 📂 Scan Your Code (no target needed)

Point AI-DAST-ING at a codebase — a Git URL, a local path, or an uploaded zip — and
it scans the source directly. No deployed URL, no infrastructure to stand up.

```bash
# Source review (SAST): audit the code, no running target required
ai-dast-ing --source ./my-app --code-scan review

# Provision + DAST: build & run the app locally, then pentest the running instance
ai-dast-ing --source https://github.com/org/app.git --code-scan provision
```

| Code-scan mode | What it does | Verification level |
| -------------- | ------------ | ------------------ |
| `review` | Reads the source, traces user input from entry point → dangerous sink, and reports reachable vulnerabilities. No live target. | **Source-verified** — proven reachable in code (clearly labeled as not runtime-exploited). |
| `provision` | Inspects the repo, builds and runs the app on a loopback port, then runs whitebox-guided DAST against the running instance. Falls back to `review` if the app can't be built. | **Exploit-verified** — reproduced against the running app. |

- `--source` accepts a Git URL (shallow-cloned), a local directory, or a path to
  an uploaded/extracted archive. In the Web UI / hosted app you can also upload a
  `.zip` of your codebase (`POST /api/upload-source`).
- You can still combine a repo **and** a live target for classic whitebox
  augmentation — that path is unchanged. Code-scan modes are for when the
  codebase is the whole subject.

> Provision mode runs your app's build/start commands in the agent's sandbox and
> only pentests the single loopback port it stood the app up on — the dashboard
> and everything else on the machine stay out of scope.

## 🧭 Methodology

AI-DAST-ING organizes autonomous testing into 22 phases.

| Phase | Focus                                      |
| ----: | ------------------------------------------ |
|     1 | Reconnaissance                             |
|     2 | Manual vulnerability discovery             |
|     3 | Directory and file discovery               |
|     4 | CORS and cookie analysis                   |
|     5 | Authentication and session testing         |
|     6 | Injection testing                          |
|     7 | SSRF testing                               |
|     8 | IDOR and broken access control             |
|     9 | API and GraphQL testing                    |
|    10 | File upload testing                        |
|    11 | Deserialization and RCE                    |
|    12 | Race conditions and business logic         |
|    13 | Subdomain takeover                         |
|    14 | Open redirect testing                      |
|    15 | Email security testing                     |
|    16 | Cloud and infrastructure                   |
|    17 | WebSocket testing                          |
|    18 | CMS-specific testing                       |
|    19 | Broken link hijacking and content spoofing |
|    20 | Exploit verification                       |
|    21 | Novel vulnerability discovery              |
|    22 | Final report                               |

Phase selection in the Web UI lets you run every phase or only the subset needed for a specific engagement.

## 📄 Reports

Reports are generated as PDF files and can include:

| Section     | Included content                                                                |
| ----------- | ------------------------------------------------------------------------------- |
| 📌 Summary     | Executive summary, target metadata, scan metadata, and severity overview.       |
| 🐞 Findings    | Verified findings, CVSS details, technical analysis, and exploitation proof.    |
| 🔬 Evidence    | Proof of concept commands, scripts, payload notes, and supporting observations. |
| 🩹 Remediation | Fix guidance and prioritized next steps.                                        |
| 🎨 Branding    | Company/target name and uploaded logo.                                          |

Reports are available from the scan detail page and the Reports page. Report rows support opening, downloading, and deletion.

## 🔧 Settings

Most operational settings can be changed from the Web UI under Settings.

| Area          | Examples                                                            |
| ------------- | ------------------------------------------------------------------- |
| 🤝 Engagement    | Dashboard request rate limits                                       |
| 🧠 LLM           | Model, API key, API base, reasoning effort, retries, max iterations |
| 📬 AgentMail     | Pod and API key                                                     |
| 🔔 Notifications | Discord webhook and minimum severity, Telegram bot token, chat ID, minimum severity, and opt-in scan-completion summaries |
| 🕵️ Proxy         | Proxy URL, proxy file, rotation, TLS verification                   |
| 🧱 Runtime       | Workspace, browser path, auto-install controls                      |
| 🔐 Security      | Dashboard username, password, password hash, bind address           |
| 📈 Resources     | CPU/RAM/disk thresholds and scan concurrency budget                 |

Some settings require a restart because they affect process startup or server binding. The UI marks those fields.

## 🧾 Environment Variables

### 🧱 Core

| Variable                             | Default          | Description                                            |
| ------------------------------------ | ---------------- | ------------------------------------------------------ |
| `AIDASTING_LLM`                       | none             | Provider-native model ID used for LLM requests.        |
| `AIDASTING_LLM_PROVIDER`              | none             | Provider selected by the dashboard, stored separately from the model ID. |
| `AIDASTING_API_KEY`                   | none             | Required LLM provider API key.                         |
| `AIDASTING_API_BASE`                  | provider default | Custom OpenAI-compatible API base URL.                 |
| `AIDASTING_REASONING_EFFORT`          | `high`           | Reasoning effort: `none`, `low`, `medium`, `high`, or `xhigh` (`xhigh` maps to `high` for Ollama). |
| `AIDASTING_LANGUAGE`                   | `en`             | Output language for AI-generated prose (agent reasoning, notes, findings, report content, post-scan chat). `en` or `zh-CN`. Technical tokens (payloads, commands, URLs, CVE/CWE IDs) always stay in their original form. Non-Latin languages render in the dashboard and HTML report automatically. |
| `AIDASTING_PDF_CJK_FONT`               | none             | Absolute path to a TrueType (`.ttf`) font with CJK glyphs, used to render non-Latin languages (e.g. Simplified Chinese) in the exported **PDF** report. Only `.ttf` is supported (not `.ttc`/`.otf`). Without it, the PDF falls back to core fonts and non-Latin glyphs will not render (the HTML report is unaffected). |
| `AIDASTING_OLLAMA_COMPATIBLE`         | `false`          | Apply Ollama reasoning semantics to a custom endpoint on a non-standard port. Port `11434` is detected automatically. |
| `AIDASTING_LLM_MAX_RETRIES`           | `5`              | Retry count for transient LLM failures.                |
| `AIDASTING_MEMORY_COMPRESSOR_TIMEOUT` | `30`             | Timeout in seconds for context compression.            |
| `AIDASTING_MAX_ITERATIONS`            | `0`              | Agent iteration cap. `0` means unlimited.              |
| `AIDASTING_PPROF_ADDR`                | none             | Opt-in Go profiler. When set (e.g. `127.0.0.1:6060`), starts a standalone pprof server at `/debug/pprof/` on that address for CPU/heap diagnosis. Disabled by default. Exposes process internals — bind loopback and reach it via an SSH tunnel; never expose publicly. |
| `GEMINI_API_KEY`                     | none             | Optional Gemini key for web-search enrichment.         |

### 🔒 Web and Security

| Variable                 | Default           | Description                        |
| ------------------------ | ----------------- | ---------------------------------- |
| `AIDASTING_BIND`          | `127.0.0.1`       | Web server listen address.         |
| `AIDASTING_ALLOW_LOCAL_TARGETS` | `false`     | Allow scanning locally-hosted apps (localhost / 127.0.0.1 / private IPs) on a self-hosted install. The dashboard's own listener is always protected. Leave off on shared/hosted deployments. |
| `AIDASTING_DISABLE_AUTO_DELEGATE` | `false` | Skip the specialist wave entirely. The root agent does all testing itself (deeper, slower). |
| `AIDASTING_CHECKLIST` | `full` | Methodology depth: `full` (comprehensive 22-phase, default) or `professional` (compact). The full checklist finds significantly more vulnerabilities. |
| `AIDASTING_USERNAME`      | none              | Dashboard username.                |
| `AIDASTING_PASSWORD`      | none              | Dashboard password.                |
| `AIDASTING_PASSWORD_HASH` | none              | Preferred bcrypt password hash.    |
| `AIDASTING_WORKSPACE`     | current directory | Workspace root for scan execution. |

### 🤝 Integrations

| Variable                        | Default | Description                              |
| ------------------------------- | ------- | ---------------------------------------- |
| `AGENTMAIL_POD`                 | none    | AgentMail pod identifier.                |
| `AGENTMAIL_API_KEY`             | none    | AgentMail API key.                       |
| `AIDASTING_DISCORD_WEBHOOK`      | none    | Global Discord webhook.                  |
| `AIDASTING_DISCORD_MIN_SEVERITY` | none    | Minimum severity sent to Discord.        |
| `AIDASTING_TELEGRAM_BOT_TOKEN`   | none    | Telegram bot token from @BotFather.      |
| `AIDASTING_TELEGRAM_CHAT_ID`      | none    | Telegram chat/channel ID (numeric or @username). |
| `AIDASTING_TELEGRAM_MIN_SEVERITY`| none    | Minimum severity sent to Telegram.      |
| `AIDASTING_NOTIFY_SCAN_COMPLETE` | `false` | Send end-of-scan summaries to configured Discord/Telegram destinations. This is opt-in and does not affect per-vulnerability alerts. |
| `CAIDO_PORT`                    | `0`     | Caido proxy port. `0` means auto-detect. |
| `CAIDO_API_TOKEN`               | none    | Caido API token.                         |

### 🚦 Rate Limits, Proxy, and Runtime

| Variable                       | Default      | Description                                        |
| ------------------------------ | ------------ | -------------------------------------------------- |
| `AIDASTING_RATE_LIMIT_REQUESTS` | `60`         | Dashboard requests per window.                     |
| `AIDASTING_RATE_LIMIT_WINDOW`   | `60`         | Dashboard rate-limit window in seconds.            |
| `AIDASTING_RATE_RPS`            | `10`         | Sustained outbound request rate.                   |
| `AIDASTING_RATE_BURST`          | `20`         | Outbound burst size.                               |
| `AIDASTING_USE_PROXY`           | `false`      | Enable proxy routing.                              |
| `AIDASTING_PROXY_REQUIRED`      | `false`      | Require one upstream proxy for target HTTP/browser paths without direct fallback. |
| `AIDASTING_PROXY_URL`           | none         | Single proxy URL. Overrides proxy file.            |
| `AIDASTING_PROXY_FILE`          | none         | File containing one proxy per line.                |
| `AIDASTING_PROXY_ROTATION`      | `roundrobin` | Proxy rotation strategy: `roundrobin` or `random`. |
| `AIDASTING_TLS_SKIP_VERIFY`     | `false`      | Skip TLS verification for testing traffic.         |
| `AIDASTING_DISABLE_BROWSER`     | `false`      | Disable browser automation.                        |
| `AIDASTING_BROWSER_PATH`        | auto         | Custom Chrome/Chromium executable path.            |
| `AIDASTING_ALLOW_AUTO_INSTALL`  | root only    | Permit automatic package installation.             |
| `AIDASTING_AUTO_INSTALL_SUDO`   | `false`      | Permit sudo-prefixed auto-installs.                |

## 🔤 Provider Prefixes

When `AIDASTING_API_BASE` is empty, AI-DAST-ING infers provider defaults from the model prefix.

| Prefix       | Default API base                               |
| ------------ | ---------------------------------------------- |
| `openai/`    | `https://api.openai.com/v1`                    |
| `anthropic/` | `https://api.anthropic.com`                    |
| `deepseek/`  | `https://api.deepseek.com/v1`                  |
| `groq/`      | `https://api.groq.com/openai/v1`               |
| `google/`    | `https://generativelanguage.googleapis.com/v1` |
| `gemini/`    | `https://generativelanguage.googleapis.com/v1` |
| `ollama/`    | `http://localhost:11434/v1`                    |
| `minimax/`   | `https://api.minimax.io/v1`                    |

Model names are not hard-coded to this list. The Settings page accepts typed model IDs so newer provider models can be used without waiting for a UI dropdown update.

## 💻 CLI Reference

| Flag                   | Alias | Description                                |
| ---------------------- | ----- | ------------------------------------------ |
| `--web`                | `-w`  | Start the Web UI.                          |
| `--port <port>`        | `-p`  | Web UI port. Default: `9137`.              |
| `--bind <addr>`        | none  | Bind address. Default: `127.0.0.1`.        |
| `--target <target>`    | `-t`  | Target URL, host, IP, or path. Repeatable. |
| `--instruction <text>` | `-i`  | Custom scan instructions.                  |
| `--model <model>`      | `-m`  | Override `AIDASTING_LLM` for this run.      |
| `--update`             | `-up` | Update to the latest release.              |
| `--version`            | `-v`  | Print version.                             |
| `--start`              | none  | Install and start the system service.      |
| `--stop`               | none  | Stop the system service.                   |
| `--restart`            | none  | Restart the system service.                |
| `--uninstall`          | none  | Remove the system service.                 |
| `--help`               | `-h`  | Show help.                                 |

## 📡 API Summary

| Method   | Endpoint                     | Purpose                                       |
| -------- | ---------------------------- | --------------------------------------------- |
| `POST`   | `/api/scan`                  | Start or save a scan.                         |
| `POST`   | `/api/stop`                  | Stop all running scans.                       |
| `GET`    | `/api/status`                | Current global status.                        |
| `GET`    | `/api/scans`                 | List scans.                                   |
| `GET`    | `/api/scans/:id`             | Get scan detail.                              |
| `DELETE` | `/api/scans/:id`             | Delete a scan and its report data.            |
| `GET`    | `/api/findings`              | List all findings (deduplicated across scans). |
| `GET`    | `/api/findings/summary`      | Severity tally across all scans.             |
| `GET`    | `/api/report/:id`            | Download a PDF report.                        |
| `GET`    | `/api/instances`             | List live and historical instances.           |
| `GET`    | `/api/instances/:id/events`  | Get buffered event history.                   |
| `POST`   | `/api/instances/:id/stop`    | Stop a specific instance.                     |
| `POST`   | `/api/instances/:id/start`   | Start a saved or completed scan as a new run. |
| `POST`   | `/api/instances/:id/restart` | Restart with the same configuration.          |
| `POST`   | `/api/instances/:id/pause`   | Pause a running scan.                         |
| `POST`   | `/api/instances/:id/resume`  | Resume a paused scan.                         |
| `POST`   | `/api/upload-logo`           | Upload a report logo.                         |
| `POST`   | `/api/upload-targets`        | Upload a target list.                         |
| `GET`    | `/api/settings/environment`  | List editable environment settings.           |
| `POST`   | `/api/settings/environment`  | Save environment settings.                    |
| `GET`    | `/api/settings/llm`          | Get LLM settings.                             |
| `POST`   | `/api/settings/llm`          | Save LLM settings.                            |
| `GET`    | `/api/settings/agentmail`    | Get AgentMail settings.                       |
| `POST`   | `/api/settings/agentmail`    | Save AgentMail settings.                      |
| `GET`    | `/ws`                        | WebSocket live event stream.                  |

## 💾 Data Storage

Web-mode scan data is stored under:

```text
~/ai-dast-ing-data/
|-- _saved/
|-- logos/
|-- queue_state.json
`-- <target>/
    `-- <date>/
        `-- <scan-id>/
            |-- scan.json
            `-- report.pdf
```

The server keeps historical scan records on disk so the UI can recover after refresh or restart.

In the Docker image and the Helm chart, this directory is the `/data` volume (`AIDASTING_DATA_DIR=/data`), persisted to a named volume or a PVC.

## 🧪 Development

| Task                        | Command                       |
| --------------------------- | ----------------------------- |
| 📦 Install Web UI dependencies | `make webui-install`          |
| 🔨 Build everything            | `make build`                  |
| ✅ Run tests                   | `go test ./...`               |
| 🖥️ Run Web UI from source      | `go run ./cmd/ai-dast-ing --web` |
| ⚡ Run frontend dev server     | `make webui-dev`              |

## 🚨 Safety Notes

- Use AI-DAST-ING only against authorized targets.
- Do not run active testing against third-party systems without permission.
- Review scan instructions before launching.
- Configure rate limits and proxy settings to match engagement rules.
- Exposing the dashboard externally requires authentication.
- Auto-install is disabled by default for non-root users and should be enabled only when you trust the environment.

## 📜 License

AI-DAST-ING is released under the Apache License 2.0. See [LICENSE](LICENSE).

## 🔗 Links

| Resource      | Link                                                                             |
| ------------- | -------------------------------------------------------------------------------- |
| ☁️ AI-DAST-ING Cloud | [www.ai-dast-ing.com](https://www.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=links_table) · [pricing](https://www.ai-dast-ing.com/pricing?utm_source=github&utm_medium=readme&utm_campaign=oss_to_cloud&utm_content=links_table_pricing) |
| 🤖 GitHub App     | [Free security review on every PR](https://github.com/apps/ai-dast-ing)              |
| 📖 Documentation | [docs.ai-dast-ing.com](https://docs.ai-dast-ing.com/?utm_source=github&utm_medium=readme&utm_campaign=oss_docs&utm_content=links_table)   |
| 💬 Questions     | [GitHub Discussions](https://github.com/ai-dast-ing/ai-dast-ing/discussions)             |
| 🐛 Issues        | [github.com/ai-dast-ing/ai-dast-ing/issues](https://github.com/ai-dast-ing/ai-dast-ing/issues) |
| 🔒 Security      | [SECURITY.md](SECURITY.md) · [Disclosure program](https://www.ai-dast-ing.com/vdp)    |
| ☕ Support       | [buymeacoffee.com/xalgord](https://buymeacoffee.com/xalgord)                     |
