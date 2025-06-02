#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

if command -v anchor >/dev/null 2>&1; then
  warn "Anchor is already installed. Skipping installation."
else
  info "Installing Anchor..."
  brew install anchordotdev/tap/anchor || true
  success "Anchor installed successfully!"
fi

info "⚠️ Run to initialize Anchor..."
info "anchor lcl"

info "⚠️ Now run:"
info "anchor service env --org <ORG_NAME> --realm localhost --service kind-anchor-lab --env-output dotenv"

warn "[ACTION REQUIRED] Paste the following ACME credentials into:"
info "anchor-lab/secrets.yaml"
warn "Use the template in: anchor-lab/secrets-template.yaml"
