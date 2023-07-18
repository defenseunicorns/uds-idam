.PHONY: k3d keycloak

cluster:
	k3d cluster delete -c k3d/k3d.yaml
	k3d cluster create -c k3d/k3d.yaml
	zarf init --components=git-server --confirm
k3d:
	cd k3d && zarf package create --tmpdir=/tmp --architecture amd64 --confirm
	cd k3d && zarf package deploy --confirm zarf-package-uds-idam-k3d-amd64-0.1.tar.zst
keycloak:
	cd keycloak && zarf-git package create --tmpdir=/tmp --architecture amd64 --confirm
	cd keycloak && zarf-git package deploy --confirm zarf-package-keycloak-amd64-0.1.tar.zst
new: cluster k3d keycloak
