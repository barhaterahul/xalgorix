#!/usr/bin/env bash
# Container entrypoint for the AI-DAST-ING image.
#
# The image binds 0.0.0.0 (so the published port works), but the engine refuses
# to bind a non-loopback address without dashboard auth. Rather than fail a
# plain `docker run`, we generate a random admin password when none is supplied,
# print it once, and start. Operators can override by passing their own
# AIDASTING_USERNAME + AIDASTING_PASSWORD (or AIDASTING_PASSWORD_HASH).
set -euo pipefail

# Persist dashboard-configured settings on the /data volume. The engine writes
# runtime settings (LLM model/key, integrations, etc.) to ~/.ai-dast-ing.env
# (=/root/.ai-dast-ing.env). Symlinking it onto /data means anything you set under
# Settings survives `docker run --rm` / container recreation, not just restarts.
mkdir -p /data
if [ ! -e /data/.ai-dast-ing.env ]; then
  if [ -f /root/.ai-dast-ing.env ] && [ ! -L /root/.ai-dast-ing.env ]; then
    mv /root/.ai-dast-ing.env /data/.ai-dast-ing.env
  else
    : >/data/.ai-dast-ing.env
  fi
fi
ln -sf /data/.ai-dast-ing.env /root/.ai-dast-ing.env

bind="${AIDASTING_BIND:-0.0.0.0}"

# Is the bind address loopback (no auth required by the engine)?
is_loopback=false
case "$bind" in
  127.0.0.1 | localhost | ::1 | "") is_loopback=true ;;
esac

# Is dashboard auth already configured?
has_auth=false
if [ -n "${AIDASTING_USERNAME:-}" ] && { [ -n "${AIDASTING_PASSWORD:-}" ] || [ -n "${AIDASTING_PASSWORD_HASH:-}" ]; }; then
  has_auth=true
fi

if [ "$is_loopback" = false ] && [ "$has_auth" = false ]; then
  export AIDASTING_USERNAME="${AIDASTING_USERNAME:-admin}"
  export AIDASTING_PASSWORD="$(openssl rand -base64 24 | tr -dc 'A-Za-z0-9' | head -c 20)"
  echo "============================================================"
  echo "  AI-DAST-ING — no dashboard auth was provided."
  echo "  Generated one-time credentials so the container can start:"
  echo ""
  echo "      username: ${AIDASTING_USERNAME}"
  echo "      password: ${AIDASTING_PASSWORD}"
  echo ""
  echo "  Override by setting AIDASTING_USERNAME + AIDASTING_PASSWORD"
  echo "  (or AIDASTING_PASSWORD_HASH). Rotate these before exposing"
  echo "  the dashboard on an untrusted network."
  echo "============================================================"
fi

exec ai-dast-ing "$@"
