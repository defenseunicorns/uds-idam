# Defense Unicorns UDS Identity and Access Management (IDAM)

Pre-built Zarf Package of to support identity and access management to compliment a [DUBBD](https://github.com/defenseunicorns/uds-package-dubbd) deployment. 

## Prerequisites

- Zarf is installed locally with a minimum version of [v0.28.3](https://github.com/defenseunicorns/zarf/releases/tag/v0.28.3)
- Optional: A working Kubernetes cluster on v1.26+ -- e.g k3d, k3s, KinD, etc (Zarf can be used to deploy a built-in k3s distribution)
- Working kube context (`kubectl get nodes` <-- this command works)
- Cypress testing requires [Node.js version 16.x, 18.x, 20.x](https://docs.cypress.io/guides/getting-started/installing-cypress#Nodejs)


### Getting Started
```bash
# Create a new k3d cluster with DUBBD + UDS-SSO + UDS-IDAM and an example mission application protected by SSO:
make cluster/full
```


### Zarf Variables Configuration

| Name                  | Description                         | Default                  | Type  | Notes                   |
|-----------------------|-------------------------------------|--------------------------|-------|-------------------------|
| REALM                 | Keycloak realm name                 | default-realm            |       |                         |
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

Before commiting it is recommended to run tests. Use the make target: `make test/idam` to run the smoke tests.

Release Please assumes you are using [Conventional Commit messages](https://www.conventionalcommits.org/).

The most important prefixes you should have in mind are:

- `fix:` which represents bug fixes, and correlates to a [SemVer](https://semver.org/)
  patch.
- `feat:` which represents a new feature, and correlates to a SemVer minor.
- `feat!:`,  or `fix!:`, `refactor!:`, etc., which represent a breaking change
  (indicated by the `!`) and will result in a SemVer major.

When the change is merged to the trunk, Release Please will calculate what changes are included and will create another PR to increase the version and tag a new release. This will also automatically generate a new set of packages in the OCI registry.

### Cypress Testing

#### [Cypress Docs](https://docs.cypress.io/)

| FileName                  | Description                     |
|---------------------------|---------------------------------|
| [package.json](cypress/package.json) | Cypress is a node based framework and depends on a lot of node artifacts. The package.json file defines useful scripts and dependencies that are necessary for running cypress tests.       |
| [package-lock.json](cypress/package-lock.json) | File for maintaining and keep track of dependency versions across environments and developers      |
| [cypress.config.js](cypress/cypress.config.js) | A configuration file that's a great place to put reusable behavior such as custom commands or global overrides that you want to be applied and available to all of your spec files. For example turning off video recording of tests run with `cypress run`. [More Configuration options](https://docs.cypress.io/guides/references/configuration)     |
| [e2e/*.cy.js](cypress/e2e/) | These files are where the Cypress tests are kept and defined      |
| [fixtures/*.json](cypress/fixtures/) | Fixtures are used as external pieces of static data that can be used by your tests    |
| [support/commands.js](cypress/support/commands.js) | Very similiar to config files but for adding Cypress commands that are more complex, for example adding beforeEach and AfterEach methods or in the case of IdAM, a Login and Logout method    |
| [support/e2e.js](cypress/support/e2e.js) | This file controls if the support/commands.js file is served up automatically to the e2e tests      |

#### Current Tests

| [Admin Authn Console Tests](cypress/e2e/admin_login.cy.js) | Description |
|---------------------------|---------------------------------|
| Verify Keycloak Admin Console is Reachable | Test to make sure that the admin console is up and reachable for cypress testing |
| Successfully Login | Validate the flow where an admin is presented the Admin Authn Console Login page, admin enters their username and password and clicks the submit button. Then they should be inside of the console and there should be at a minimum three active cookies for tracking their session in keycloak. |
| Invalid Credential Login | Validate that when an admin enters the wrong username or password that the they dont get authenticated and instead there is a warning popup that they entered the wrong credentials. |

| [User Authn Console Tests](cypress/e2e/user.cy.js) | Description |
|---------------------------|---------------------------------|
| Before | Before the tests in this spec, a test realm, client, and user will be created |
| User Login | Test to verify that when a test user access a URL that is protected by keycloak, they are prompted to login, and can successfully authenticate. |
| After | After the tests have completed the test realm, client, and user will be removed |

#### NPM Scripts
`cy.open` - `cypress open` - Setup the interactive Cypress Testing UI

`cy.run` - `cypress run -browser chrome` - Script for running all cypress tests headlessly with a chrome browser

#### Running Tests

An [npm script](package.json#L7) has been configured to run all Cypress Tests : `npm run cy.run`

Alternatively a [make target](Makefile#L62) has been created pointing to the npm script, this will also run the npm install process: `make test/idam`

To run a specific spec file use the `-s <spec file name>` flag with the npm test script : `npm run cy.run -- -s cypress/e2e/example_spec.cy.js`