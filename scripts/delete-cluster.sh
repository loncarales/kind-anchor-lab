#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

if ! kind get clusters | grep -q '^dev-cluster$'; then
  warn "Kind cluster 'dev-cluster' does not exist. Skipping deletion."
  exit 0
fi

info "Deleting Kind cluster..."
kind delete cluster --name dev-cluster
success "Cluster deleted successfully!"
