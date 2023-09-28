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


# Build all CI Test requirements (Postgres, IDAM from oci, IDAM from source, uds bundle with zarf / metallb / dubbd )
build/all-ci: build build/idam-postgres build/idam build/ci-upgrade-idam-published build/ci-upgrade-idam-source

# Build the CI upgrade test for published IDAM image
build/ci-upgrade-idam-published: | build
	cd test/ci-upgrade-idam && uds bundle create --set IDAM_VERSION=$(IDAM_VERSION) --set INIT_VERSION=$(ZARF_VERSION) --set METALLB_VERSION=$(METALLB_VERSION) --set DUBBD_VERSION=$(DUBBD_K3D_VERSION) --confirm





# Build the CI upgrade test for source IDAM image
build/ci-upgrade-idam-source: | build
	cd test/ci-upgrade-idam/source-idam && uds bundle create --set INIT_VERSION=$(ZARF_VERSION) --set METALLB_VERSION=$(METALLB_VERSION) --set DUBBD_VERSION=$(DUBBD_K3D_VERSION) --confirm

# Deploy the CI upgrade test for published IDAM image
deploy/ci-upgrade-idam-published:
	cd test/ci-upgrade-idam && uds bundle deploy uds-bundle-*.tar.zst --confirm

# Deploy the CI upgrade test for source IDAM image
deploy/ci-upgrade-idam-source:
	cd test/ci-upgrade-idam/source-idam && uds bundle deploy uds-bundle-*.tar.zst --confirm





# # Deploy the CI upgrade test bundle
# deploy/ci-test-setup:
# 	cd test/ci-upgrade-idam && uds bundle deploy uds-bundle-*.tar.zst --confirm

# # Deploy the latest published idam image
# deploy/published-idam:
# 	zarf package deploy oci://ghcr.io/defenseunicorns/uds-capability/uds-idam:$(IDAM_VERSION)-amd64 --confirm
	
# # Deploy idam branch from source
# deploy/source-idam:	
# 	zarf package deploy build/zarf-package-uds-idam*.tar.zst --confirm

# # Remove the latest published idam image
# remove/published-idam:
# 	zarf package remove oci://ghcr.io/defenseunicorns/uds-capability/uds-idam:$(IDAM_VERSION)-amd64 --confirm


cleanup:
	rm -rf build run tmp on_failure.sh bigbang.dev.cert bigbang.dev.key customreg.yaml realm.json truststore.jks.b64 values-keycloak.yaml test/ci-upgrade-idam/run test/ci-upgrade-idam/tmp test/ci-upgrade-idam/bigbang.dev.cert test/ci-upgrade-idam/bigbang.dev.key test/ci-upgrade-idam/customreg.yaml test/ci-upgrade-idam/on_failure.sh test/ci-upgrade-idam/realm.json test/ci-upgrade-idam/truststore.jks.b64 test/ci-upgrade-idam/uds-bundle-uds-idam* test/ci-upgrade-idam/values-keycloak.yaml test/ci-upgrade-idam/source-idam/uds-bundle-uds-idam* test/ci-upgrade-idam/source-idam/run test/ci-upgrade-idam/source-idam/tmp test/ci-upgrade-idam/source-idam/bigbang.dev.cert test/ci-upgrade-idam/source-idam/bigbang.dev.key test/ci-upgrade-idam/source-idam/customreg.yaml test/ci-upgrade-idam/source-idam/on_failure.sh test/ci-upgrade-idam/source-idam/realm.json test/ci-upgrade-idam/source-idam/truststore.jks.b64 test/ci-upgrade-idam/source-idam/values-keycloak.yaml