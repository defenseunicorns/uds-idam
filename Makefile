# renovate: datasource=docker depName=ghcr.io/defenseunicorns/packages/dubbd-k3d extractVersion=^(?<version>\d+\.\d+\.\d+)
DUBBD_VERSION := 0.11.0

# renovate: datasource=github-tags depName=defenseunicorns/zarf
ZARF_VERSION := v0.31.0

# renovate: datasource=github-tags depName=defenseunicorns/uds-package-metallb
METALLB_VERSION := 0.0.1

# renovate: datasource=docker depName=ghcr.io/defenseunicorns/uds-capability/uds-sso extractVersion=^(?<version>\d+\.\d+\.\d+)
SSO_VERSION := 0.1.3

# x-release-please-start-version
IDAM_VERSION := 0.1.14
# x-release-please-end

ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

# Export all make variables to subsequent subshells running recipes below
export

cluster/create:
	k3d cluster delete -c dev/dubbd-bundle/k3d.yaml
	k3d cluster create -c dev/dubbd-bundle/k3d.yaml

cluster/full: cluster/create build/all deploy/all  ## This will destroy any existing cluster, create a new one, then build and deploy all

cluster/bundle: cluster/create build/bundles deploy/bundle

build/all: build build/extra-jar build/idam-postgres build/idam build/bundles

build/published: build build/idam-postgres pull/published build/bundles

build: ## Create build directory
	mkdir -p build

build/bundles: build/dubbd-bundle build/idam-bundle

build/dubbd-bundle: | build
	cd dev/dubbd-bundle && cat uds-bundle.yaml.tmpl | envsubst > uds-bundle.yaml
	cd dev/dubbd-bundle && uds create --confirm

build/idam-bundle: | build
	cd dev && cat uds-bundle.yaml.tmpl | envsubst > uds-bundle.yaml
	cd dev && uds create --confirm

build/extra-jar: | build
	cd build && zarf package create ../pkg-deps/extra-jar --confirm

build/idam: | build
	cd idam && zarf package create --tmpdir=/tmp --architecture amd64 --confirm --output ../build

build/idam-postgres: | build
	cd build && zarf package create ../pkg-deps/postgres --confirm

deploy/all: deploy/dubbd-bundle deploy/idam-bundle

deploy/dubbd-bundle:
	cd dev/dubbd-bundle && uds deploy uds-bundle-uds-core-dubbd-*.tar.zst --confirm

deploy/idam-bundle:
	cd dev && uds deploy uds-bundle-uds-core-idam-*.tar.zst --confirm

test/idam: ## run all cypress tests
	npm --prefix test/cypress/ install
	npm --prefix test/cypress/ run cy.run

pull/published: | build
	cd build && rm -f zarf-package-uds-idam-amd64-*.tar.zst 2> /dev/null || true
	cd build && zarf package pull oci://ghcr.io/defenseunicorns/uds-capability/uds-idam:$(IDAM_VERSION)-amd64
