#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

# Check if cloud-provider-kind is installed, if not install it
if ! command -v cloud-provider-kind &> /dev/null; then
    info "Installing cloud-provider-kind..."
    brew install cloud-provider-kind
fi

if pgrep -f "/usr/local/bin/cloud-provider-kind" > /dev/null; then
  warn "Cloud Provider for KIND is already running. Skipping start."
  exit 0
fi

info "Starting Cloud Provider for KIND..."
sudo /usr/local/bin/cloud-provider-kind
