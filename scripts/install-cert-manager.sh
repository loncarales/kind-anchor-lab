#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

info "Installing cert-manager..."
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --set crds.enabled=true
