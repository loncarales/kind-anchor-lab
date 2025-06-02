all: help

.PHONY: cluster
cluster: ## Create Kind Cluster
	@bash scripts/create-cluster.sh

.PHONY: ingress
ingress: ## Install ingress controller
	@bash scripts/install-ingress.sh

.PHONY: cloud
cloud: ## Starting Cloud Provider for KIND - run in separate terminal since it’s a long-running process
	@bash scripts/start-provider.sh

.PHONY: lint
cert-manager: ## Install cert-manager
	@bash scripts/install-cert-manager.sh

.PHONY: anchor
anchor: ## Setup anchor
	@bash scripts/setup-anchor.sh

.PHONY: anchor-lab
anchor-lab: ## Deploy anchor lab
	@bash scripts/deploy-anchor-lab.sh

.PHONY: delete
delete: ## Delete Kind Cluster
	@bash scripts/delete-cluster.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
