#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

if kind get clusters | grep -q '^dev-cluster$'; then
  warn "Kind cluster 'dev-cluster' already exists. Skipping creation."
  exit 0
fi

info "Creating Kind cluster..."
kind create cluster --name dev-cluster --config kind-config.yaml
success "Cluster created successfully!"

kind get kubeconfig --name dev-cluster > kind-dev-cluster.kubeconfig.yaml
success "Kubeconfig saved to kind-dev-cluster.kubeconfig.yaml"
