CONFIG := k3d.yaml
CLUSTER := $(shell yq '.metadata.name' $(CONFIG))
BREW_PACKAGES := colima docker kubectl k3d helm yq gettext

.PHONY: deps up down clear reset headlamp-token

deps:
	brew install $(BREW_PACKAGES)
	colima start
	docker info >/dev/null
	@echo "Docker daemon is available"

up:
	envsubst < $(CONFIG) | k3d cluster create -c -

down:
	k3d cluster delete $(CLUSTER)

clear: down
	rm -rf k3d-persistent-storage/*

reset: down up

headlamp-token:
	@kubectl create token headlamp \
		-n headlamp \
		--duration=24h | pbcopy
	@echo "Headlamp token copied to clipboard"
