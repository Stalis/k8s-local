CONFIG := k3d.yaml
CLUSTER := $(shell yq '.metadata.name' $(CONFIG))

.PHONY: up down clear reset headlamp-token

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
