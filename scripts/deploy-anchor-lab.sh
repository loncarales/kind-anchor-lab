#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/common.sh"

info "Switching to helm chart directory..."

pushd ./anchor-lab > /dev/null

# Check if secrets.yaml exists
if [ ! -f "./secrets.yaml" ]; then
    error "secrets.yaml file is missing in ./anchor-lab directory!"
    error "Please create the secrets.yaml file before deploying."
    exit 1
fi

info "Installing Helm chart..."
helm upgrade --install anchor-lab . \
  -f ./values.yaml \
  -f ./secrets.yaml \
  --namespace anchor-lab --create-namespace

success "Helm chart installed!"
popd > /dev/null
