DUBBD_K3D_VERSION := 0.5.2
ZARF_VERSION := v0.28.3
SSO_VERSION := 0.1.2
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: k3d sso test metallb

cluster/create:
	k3d cluster delete -c k3d/k3d.yaml
	k3d cluster create -c k3d/k3d.yaml

deploy/test:
	cd test-mission-app && zarf package create --tmpdir=/tmp --architecture amd64 --confirm
	cd test-mission-app && zarf package deploy -ltrace --tmpdir=/tmp --confirm zarf-package-podinfo-amd64-0.1.tar.zst

cluster/full: cluster/create build/all deploy/all  ## This will destroy any existing cluster, create a new one, then build and deploy all

build/all: build build/dubbd-pull-k3d.sha256 build/idam build/sso-pull.sha256

build: ## Create build directory
	mkdir -p build

build/sso-pull.sha256: | build ## Download dubbd k3d oci package
	zarf package pull oci://ghcr.io/defenseunicorns/uds-capability/uds-sso:$(SSO_VERSION)-amd64 --oci-concurrency 9 --output-directory build
	echo "Creating shasum of the idam package"

	shasum -a 256 build/zarf-package-uds-sso-amd64-$(SSO_VERSION).tar.zst | awk '{print $$1}' > build/pull-sso.sha256

build/dubbd-pull-k3d.sha256: | build ## Download dubbd k3d oci package
	zarf package pull oci://ghcr.io/defenseunicorns/packages/dubbd-k3d:$(DUBBD_K3D_VERSION)-amd64 --oci-concurrency 9 --output-directory build
	echo "Creating shasum of the dubbd-k3d package"
	shasum -a 256 build/zarf-package-dubbd-k3d-amd64-$(DUBBD_K3D_VERSION).tar.zst | awk '{print $$1}' > build/dubbd-pull-k3d.sha256

build/idam: | build ## Download idam
	cd idam && zarf package create --tmpdir=/tmp --architecture amd64 --confirm --output ../build

deploy/all: deploy/init deploy/metallb deploy/dubbd-k3d deploy/idam deploy/sso deploy/test

deploy/init:
	zarf init --components=git-server --confirm

deploy/dubbd-k3d: ## Deploy the k3d flavor of DUBBD
	cd ./build && zarf package deploy zarf-package-dubbd-k3d-amd64-$(DUBBD_K3D_VERSION).tar.zst --set=APPROVED_REGISTRIES="127.0.0.1* | ghcr.io/defenseunicorns/pepr* | ghcr.io/stefanprodan* | registry1.dso.mil" --confirm

deploy/idam: ## Deploy idam
	cd ./build && zarf package deploy zarf-package-uds-idam-amd64-*.tar.zst --confirm

deploy/sso: ## Deploy sso
	cd ./build && zarf package deploy --confirm zarf-package-uds-sso-amd64-*.tar.zst

deploy/metallb:
	cd metallb && zarf package create --tmpdir=/tmp --architecture amd64 --confirm
	cd metallb && zarf package deploy -ltrace --tmpdir=/tmp --confirm zarf-package-metallb-amd64-*.tar.zst

deploy/test:
	cd test-mission-app && zarf package create --tmpdir=/tmp --architecture amd64 --confirm
	cd test-mission-app && zarf package deploy -ltrace --tmpdir=/tmp --confirm zarf-package-podinfo-amd64-*.tar.zst
