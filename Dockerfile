# AI-DAST-ING — AI autonomous penetration testing platform (slim, web/API-focused).
#
# Slim runtime: Debian bookworm-slim + exactly the toolset the engine's
# auto-install map (internal/tools/terminal → packageMap) drives for web/API
# work, preinstalled so scans never wait on a lazy install:
#
#   core .......... curl, wget, git, jq, python3/pipx, openssl, nmap, dig/whois
#   discovery ..... subfinder, dnsx, httpx, naabu, katana
#   fuzz/content .. ffuf, gobuster, SecLists (shallow clone)
#   xss ........... dalfox
#   archives ...... gau, waybackurls
#   params ........ arjun (pipx)
#   browser DAST .. Chromium (browser_action / verify_xss / pageagent)
#   nuclei ........ latest engine + latest templates (dedicated cache-bustable layer)
#
# Everything else in the packageMap (gospider, hakrawler, feroxbuster, masscan,
# semgrep, bandit, scrapling, paramspider, …) stays runtime-installable: the
# image ships the Go toolchain + pipx and runs as ROOT on purpose, and the
# engine only enables package auto-install for uid 0
# (internal/config: AllowAutoInstall defaults to os.Getuid()==0). The container
# is the isolation boundary — treat it as a disposable, network-isolated
# scanning sandbox and never expose the dashboard without auth.
#
# Deliberately NOT included vs the old Kali image: the kali-tools-*
# metapackages (~7 GB), semgrep/bandit/brakeman SAST engines (whitebox SAST is
# code_search-driven; semgrep stays lazy-installable via pipx), trufflehog/gh,
# masscan/socat/tcpdump (network pivots — not web/API work), cargo/npm and the
# Rust/Ruby toolchains (their packageMap routes are unavailable; Go + pipx
# routes cover the 3+ set). Final size ≈ 1.3–1.5 GB vs ≈ 10 GB for the Kali build.
#
# Build:  docker build -t barhaterahul/ai-dast-ing:latest .
# Run:    docker run --rm -p 9137:9137 \
#           --privileged \
#           -e AIDASTING_LLM=openai/gpt-5.6 \
#           -e AIDASTING_API_KEY=your_provider_api_key \
#           -v ai-dast-ing-data:/data \
#           barhaterahul/ai-dast-ing:latest
#
# --privileged gives the toolset the same host-like access it has when run
# natively as root. Docker's DEFAULT sandbox drops capabilities (NET_ADMIN, …)
# and applies a seccomp/AppArmor filter that breaks low-level tools (iptables,
# route/interface changes, ARP-spoof/MITM, tun/tap VPNs, ptrace debuggers,
# masscan interface tuning, naabu's raw sockets). An image CANNOT grant itself
# capabilities — they are set at run time — so pass --privileged (or the
# narrower --cap-add=NET_ADMIN --cap-add=NET_RAW --cap-add=SYS_PTRACE
# --security-opt seccomp=unconfined), or just use docker-compose.yml which
# sets privileged mode for you.
#
# Then open http://127.0.0.1:9137
#
# Published for linux/amd64 and linux/arm64. Release binaries also cover native
# Linux and macOS installs via the one-line installer.

# ── Stage 1: build the React web UI ──────────────────────────────────────────
FROM node:22-bookworm-slim AS webui
WORKDIR /src
# Copy the lockfile so npm ci installs the exact versions verified by the
# contributor (React 19 / TS 7 / Vite 8), instead of resolving fresh from
# the caret ranges on every rebuild. package-lock.json is now tracked in
# the repo (see .gitignore exception); the glob stays for any older build
# context that lacks it.
COPY webui/package.json webui/package-lock.json* ./webui/
# npm ci fails if package.json and the lockfile disagree — that is the
# point: a drift between the manifest and the lockfile must break the
# build rather than silently re-resolving to whatever is latest.
RUN cd webui && npm ci --no-audit --no-fund
COPY webui ./webui
COPY internal/web ./internal/web
RUN cd webui && npm run build

# ── Stage 2: build the Go binary + the Go security toolset ───────────────────
# Go 1.26+ is required: projectdiscovery/httpx v1.10.0 declares `go >= 1.26`, so
# a 1.25 builder makes `go install httpx@latest` fail (silently, via the `|| WARN`
# in the tool loop) and the image ships without the ProjectDiscovery scanner.
FROM golang:1.26-bookworm AS gobuild
# libpcap-dev is needed to compile naabu (CGO); git for module fetches.
RUN apt-get update && apt-get install -y --no-install-recommends libpcap-dev git \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
COPY --from=webui /src/internal/web/static ./internal/web/static
ARG VERSION=docker
RUN CGO_ENABLED=0 go build -ldflags "-s -w -X main.version=${VERSION}" \
    -o /out/ai-dast-ing ./cmd/ai-dast-ing/

# Latest versions of the web/API Go tools, into /go/bin. Slim-set: only what
# Option 3+ preinstalls; anything dropped here remains runtime-installable via
# the packageMap → goTools route (the Go toolchain ships in the runtime stage).
# NOTE: nuclei is deliberately NOT in this loop. It's the security-critical,
# fast-moving scanner, so it's installed + template-synced in a dedicated,
# cache-bustable layer in the runtime stage (see NUCLEI_VERSION/TOOLS_REFRESH
# below) to guarantee a fresh engine + latest templates on every refreshed build.
ENV GOBIN=/go/bin
RUN set -eux; \
    for pkg in \
      github.com/projectdiscovery/httpx/cmd/httpx@latest \
      github.com/projectdiscovery/dnsx/cmd/dnsx@latest \
      github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest \
      github.com/projectdiscovery/katana/cmd/katana@latest \
      github.com/lc/gau/v2/cmd/gau@latest \
      github.com/tomnomnom/waybackurls@latest \
      github.com/OJ/gobuster/v3@latest \
      github.com/ffuf/ffuf/v2@latest \
      github.com/hahwul/dalfox/v2@latest \
    ; do go install -v "$pkg" || echo "WARN: go install $pkg failed (installable at runtime)"; done; \
    CGO_ENABLED=1 go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest \
      || echo "WARN: naabu build failed (installable at runtime)"

# ── Stage 3: runtime — Debian slim, web/API toolset, runs as root ────────────
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Core + the apt-routed pieces of the packageMap the agent drives for web/API
# scans. Bookworm packages: netcat-openbsd provides nc; dnsutils provides
# dig/nslookup; iproute2 provides ss/ip; xxd ships its own package.
RUN set -eux; \
    apt-get -o Acquire::Retries=3 update; \
    apt-get -o Acquire::Retries=3 install -y --no-install-recommends \
      ca-certificates curl wget git jq unzip zip file tree bc xxd \
      html2text libxml2-utils binutils \
      openssl nmap netcat-openbsd whois dnsutils iproute2 libpcap0.8 \
      python3 python3-pip python3-venv pipx \
      chromium \
    && rm -rf /var/lib/apt/lists/*

# Strip file capabilities from every bundled tool so a plain `docker run` works.
#
# Debian ships some tools with file capabilities set with the EFFECTIVE bit
# (nmap's helpers, for example). Under Docker's DEFAULT security profile the
# capability bounding set drops NET_ADMIN, and the kernel fails execve() with
# EPERM whenever a binary requests an effective capability that isn't in the
# bounding set — so such binaries won't even start under a default `docker run`.
#
# The engine runs as ROOT on purpose, and root already holds NET_RAW in Docker's
# default bounding set, so these file caps are redundant: removing them lets the
# binaries exec cleanly and fall back to root's own capabilities for raw-socket
# scans.
RUN getcap -r / 2>/dev/null | awk '{print $1}' | while read -r f; do \
      setcap -r "$f" 2>/dev/null || true; \
    done || true

# Go toolchain at runtime so the agent can `go install` anything not baked in
# (the packageMap → goTools route — the auto-install safety net).
COPY --from=gobuild /usr/local/go /usr/local/go
# Prebuilt latest Go security tools → on PATH via /root/go/bin.
COPY --from=gobuild /go/bin/ /root/go/bin/
# The ai-dast-ing binary itself.
COPY --from=gobuild /out/ai-dast-ing /usr/local/bin/ai-dast-ing

ENV PATH="/usr/local/go/bin:/root/go/bin:/root/.local/bin:${PATH}" \
    GOBIN=/root/go/bin \
    HOME=/root

# SecLists — ffuf/gobuster wordlists. The engine embeds a small default list,
# but content discovery quality depends on real wordlists. Debian does not
# package seclists, and it has no packageMap route (lazy install is not
# possible), so bake it in. A full working tree is ~2.7 GB (the repo carries
# huge asset dumps we never use), so sparse-checkout only the categories the
# agent drives — Discovery/Web-Content, Discovery/DNS, Passwords credential
# lists — then drop .git. Best-effort: scans still work off the embedded list.
RUN git clone --depth 1 --filter=blob:none --sparse \
      https://github.com/danielmiessler/SecLists /usr/share/seclists \
    && cd /usr/share/seclists \
    && git sparse-checkout set Discovery/Web-Content Discovery/DNS Passwords/Common-Credentials \
    && rm -rf .git \
    || echo "WARN: seclists clone failed (embedded wordlist remains available)"

# arjun — hidden-parameter discovery (pipx). Small; pipx stays available at
# runtime as the engine's fallback for its other pipx-routed tools.
RUN pipx install arjun \
    || pip3 install --break-system-packages arjun \
    || echo "WARN: arjun prefetch failed (installable at runtime)"

# ── nuclei engine + templates: always-latest, dedicated cache-bustable layer ──
# nuclei is the security-critical, fast-moving scanner — a stale engine or stale
# vuln templates directly means missed findings. Installing it HERE (instead of
# the bulk go-tool loop in the builder) isolates it after every other expensive
# apt/tool/pipx layer, so a cache-bust re-pulls the latest engine AND templates
# cheaply, without re-running the layers above:
#
#   * default build ................ uses Docker's layer cache (fast, unchanged)
#   * --build-arg TOOLS_REFRESH=<changing value> .. forces a fresh engine +
#         templates. redeploy.sh and the release CI pass this on every build, so
#         shipped images always carry the latest nuclei + latest templates.
#   * --build-arg NUCLEI_VERSION=vX.Y.Z ........... pin the engine for repro builds.
#
# The runtime Go toolchain (copied above) builds it; the module/build caches are
# pruned afterwards so the layer stays lean. Best-effort: a network blip leaves
# nuclei runtime-installable, consistent with the rest of this image.
ARG NUCLEI_VERSION=latest
ARG TOOLS_REFRESH=
# echo references TOOLS_REFRESH so a changing value invalidates this layer's
# cache; go clean runs in the SAME RUN so the module/build caches are never
# committed to the image.
RUN echo "nuclei refresh token: ${TOOLS_REFRESH:-none}"; \
    { GOBIN=/root/go/bin go install -v "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@${NUCLEI_VERSION}" \
      && /root/go/bin/nuclei -update-templates >/dev/null 2>&1 ; } \
      || echo "WARN: nuclei engine/template refresh failed (installable at runtime)"; \
    go clean -cache -modcache 2>/dev/null || true

# Make `httpx` resolve to ProjectDiscovery's scanner. pipx/PyPI ship a Python
# `httpx` CLI (the HTTP client) that otherwise answers `httpx` and breaks the
# engine's recon (unknown flags like -silent/-title). /root/go/bin is already
# ahead of /usr/bin on PATH; also point the absolute path at the PD binary so
# nothing falls back to the Python client.
RUN if [ -x /root/go/bin/httpx ]; then ln -sf /root/go/bin/httpx /usr/bin/httpx; \
    else echo "WARN: ProjectDiscovery httpx not baked into /root/go/bin"; fi

ENV AIDASTING_BIND=0.0.0.0 \
    AIDASTING_BROWSER_PATH=/usr/bin/chromium \
    AIDASTING_DATA_DIR=/data \
    AIDASTING_ALLOW_AUTO_INSTALL=1 \
    AIDASTING_NO_AUTO_UPDATE=1

# Entrypoint generates dashboard credentials when none are supplied (the image
# binds 0.0.0.0, which the engine won't do without auth) so a plain
# `docker run` starts cleanly and securely.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /data
VOLUME ["/data"]
EXPOSE 9137

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["--web"]
