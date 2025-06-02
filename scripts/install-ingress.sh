#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

info "Installing NGINX ingress controller..."
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f node-selector-values.yaml
