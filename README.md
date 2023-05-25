# Unicorn Delivery Service: Identity and Access Management (UDS IDAM)

## Prerequisites

- Zarf version 0.27.0 or higher installed locally
- Docker installed locally (for image pulls)
- AWS EKS cluster -- k8s v1.26+
- AWS EKS cluster has zarf init package deployed (with git-server component)
- AWS KMS (with alias)
- AWS RDS
- Working kube context (`kubectl get nodes` <-- this command works)

## Build the package

```bash
# Login to the registry
set +o history
export REGISTRY1_USERNAME="YOUR-USERNAME-HERE"
export REGISTRY1_PASSWORD="YOUR-PASSWORD-HERE"
echo $REGISTRY1_PASSWORD | zarf tools registry login registry1.dso.mil --username $REGISTRY1_USERNAME --password-stdin
set -o history

# Create the zarf package
zarf package create --architecture amd64 --confirm

# (Optionally) Publish package to the OCI registry
zarf package publish examples/helm-local-chart oci://127.0.0.1:5000 --insecure
```

## Deploy the package

```bash
# Modify zarf-config.yaml as needed

# Verify all prereqs are met

# Run the zarf package deploy command
zarf package deploy --confirm zarf-package-uds-idam-*.tar.zst

# (Alternatively) Deploy from OCI
# Login to the registry
# Run the zarf package deploy command with the desired DUBBD OCI package reference 
zarf package deploy oci://ghcr.io/defenseunicorns/packages/uds-idam:0.0.1-amd64 --oci-concurrency=15
```
