# renovate: datasource=docker depName=ghcr.io/defenseunicorns/packages/dubbd-k3d extractVersion=^(?<version>\d+\.\d+\.\d+) 
DUBBD_K3D_VERSION := 0.9.0
# renovate: datasource=github-tags depName=defenseunicorns/zarf
ZARF_VERSION := v0.29.2
# renovate: datasource=github-tags depName=defenseunicorns/uds-package-metallb
METALLB_VERSION := 0.0.1
# renovate: datasource=docker depName=ghcr.io/defenseunicorns/uds-capability/uds-sso extractVersion=^(?<version>\d+\.\d+\.\d+)
SSO_VERSION := 0.1.3
# x-release-please-start-version
IDAM_VERSION := 0.1.11
# x-release-please-end
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

cluster/create:
	k3d cluster delete -c dev/k3d.yaml
	k3d cluster create -c dev/k3d.yaml

cluster/full: cluster/create build/all deploy/all  ## This will destroy any existing cluster, create a new one, then build and deploy all

cluster/bundle: cluster/create build/bundle deploy/bundle

build/all: build build/idam-postgres build/idam build/bundle

build: ## Create build directory
	mkdir -p build

build/bundle: | build
	cd dev && uds bundle create --set INIT_VERSION=$(ZARF_VERSION) --set METALLB_VERSION=$(METALLB_VERSION) --set DUBBD_VERSION=$(DUBBD_K3D_VERSION)  --confirm

build/idam: | build
	cd idam && zarf package create --tmpdir=/tmp --architecture amd64 --confirm --output ../build

build/idam-postgres: | build
	cd build && zarf package create ../pkg-deps/postgres --confirm 

deploy/all: deploy/bundle

deploy/bundle:
	cd dev && uds bundle deploy uds-bundle-uds-core-*.tar.zst --confirm

test/idam: ## run all cypress tests
	npm --prefix test/cypress/ install 
	npm --prefix test/cypress/ run cy.run


# CI TEST TARGETS

build/all-ci: build build/idam-postgres build/idam build/ci-test-setup

build/ci-test-setup: | build
	cd test/ci-upgrade-idam && uds bundle create --set INIT_VERSION=$(ZARF_VERSION) --set METALLB_VERSION=$(METALLB_VERSION) --set DUBBD_VERSION=$(DUBBD_K3D_VERSION) --confirm

deploy/ci-test-setup:
	cd test/ci-upgrade-idam && uds bundle deploy uds-bundle-uds-core-*.tar.zst --confirm

deploy/published-idam:
	zarf package deploy oci://ghcr.io/defenseunicorns/uds-capability/uds-idam:$(IDAM_VERSION)-amd64 --confirm
	
deploy/source-idam:	
	zarf package deploy build/zarf-package-uds-idam*.tar.zst --confirm

remove/published-idam:
	zarf package remove oci://ghcr.io/defenseunicorns/uds-capability/uds-idam:$(IDAM_VERSION)-amd64 --confirm
