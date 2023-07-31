# Defense Unicorns UDS Identity and Access Management (IDAM)

Pre-built Zarf Package of to support identity and access management to compliment a [DUBBD](https://github.com/defenseunicorns/uds-package-dubbd) deployment. 

## Prerequisites

- Zarf is installed locally with a minimum version of [v0.28.3](https://github.com/defenseunicorns/zarf/releases/tag/v0.28.3)
- Optional: A working Kubernetes cluster on v1.26+ -- e.g k3d, k3s, KinD, etc (Zarf can be used to deploy a built-in k3s distribution)
- Working kube context (`kubectl get nodes` <-- this command works)


### Getting Started
```bash
# Create a new k3d cluster with DUBBD + UDS-SSO + UDS-IDAM and an example mission application protected by SSO:
make cluster/full
```


### Zarf Variables Configuration

| Name                  | Description                         | Default                  | Type  | Notes                   |
|-----------------------|-------------------------------------|--------------------------|-------|-------------------------|
| REALM                 | Keycloak realm name                 | baby-yoda                |       |                         |
| DOMAIN                | Base Domain                         | bigbang.dev              |       |                         |
| KC_ADM_USER           | Default admin username              | admin                    |       |                         |
| KC_ADM_PASSWORD       | Default admin password              | sup3r-secret-p@ssword    |       |                         |
| KEYCLOAK_KEY_FILE     | X509 key file path                  | bigbang.dev.key          | FILE  |                         |
| KEYCLOAK_CERT_FILE    | X509 certificate file path          | bigbang.dev.cert         | FILE  |                         |
| REALM_IMPORT_FILE     | JSON realm import file path         | realm.json               | FILE  |                         |
| REALM_TRUSTSTORE_FILE | Keycloak truststore file path       | truststore.jks.b64       | FILE  | MUST BE BASE64 ENCODED  |
| REALM_CUSTOM_REG_FILE | Platform One plugin config file path| customreg.yaml           | FILE  |                         |
| KEYCLOAK_VALUES       | Keycloak chart values file path     | values-keycloak.yaml     | FILE  |                         |
| KEYCLOAK_DEPENDS_ON   | Keycloak dependencies               | []                       |       |                         |
| KEYCLOAK_CREATE_NAMESPACE | Create Keycloak namespace       | true                     |       |                         |


### Creating releases

The pipeline uses [release-please-action](https://github.com/google-github-actions/release-please-action) for versioning and releasing OCI packages. This will automatically update `metadata.version` field in zarf.yaml to the same version number that is used for the release tag. To make this work, the `version` field must be surrounded by Release Please's annotations,

```yaml
  # x-release-please-start-version
  version: "0.2.1"
  # x-release-please-end
```

More information on this can be found in [Release Please's documentation](https://github.com/googleapis/release-please/blob/main/docs/customizing.md#updating-arbitrary-files).

### How should I write my commits?

Release Please assumes you are using [Conventional Commit messages](https://www.conventionalcommits.org/).

The most important prefixes you should have in mind are:

- `fix:` which represents bug fixes, and correlates to a [SemVer](https://semver.org/)
  patch.
- `feat:` which represents a new feature, and correlates to a SemVer minor.
- `feat!:`,  or `fix!:`, `refactor!:`, etc., which represent a breaking change
  (indicated by the `!`) and will result in a SemVer major.

When the change is merged to the trunk, Release Please will calculate what changes are included and will create another PR to increase the version and tag a new release. This will also automatically generate a new set of packages in the OCI registry.
