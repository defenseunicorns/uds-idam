// Cypress tests for validating the user login process
describe('User Login Tests', () => {

    // Before tests setup testing Realm, Client, and User
    before(() => {

        // Use the properties fixture for configuring the admin username and password
        cy.fixture('properties.json').then((properties) => {

            // defined from fixture
            const username = properties.admin.username;
            const password = properties.admin.password;

            cy.visit('https://'+properties.admin.hostname+'/auth/admin/master/console')
            // Assert that location is the login page
            cy.url().should('include', '/auth/realms/master/protocol/openid-connect/auth?')

            // Enter Admin Username and Assert it was entered correctly
            cy.get('input[id="username"]').type(username)
            cy.get('input[id="username"]').should('have.value', username)

            // Enter Admin Password and Assert it was entered correctly
            cy.get('input[id="password"]').type(password)
            cy.get('input[id="password"]').should('have.value', password)
    
            // Click the submit login button on the login page and assert
            // that the new location is the signed in admin console page
            cy.get('input[id="kc-login"]').click()
            cy.url().should('eq', 'https://'+properties.admin.hostname+'/auth/admin/master/console/')
        })

        // Toggle the sidebar menu to be open
        cy.get('button[id="nav-toggle"]').click()
        cy.get('div[id="page-sidebar"]').should('have.class', 'pf-m-expanded')

        // Click the Realm Selection Drop Down
        cy.get('div[id="realm-select"]').contains('master').click()
        cy.get('div[id="realm-select"]').should('have.class', 'pf-m-expanded')

        // Select the Create Realm Option
        cy.get('div').contains('Create Realm').click()

        // Toggle the sidebar menu to be closed
        cy.get('button[id="nav-toggle"]').click()
        cy.get('div[id="page-sidebar"]').should('have.class', 'pf-m-collapsed')

        // Import Fixture for Realm import with a testing realm, client, and user
        cy.fixture('testing-realm-client-user-import.json', null).then((file) => {
            cy.get('input[type="file"]').selectFile(file, {force: true})
        })

        // Create the Realm
        cy.get('button').contains('Create').click()

        // Logout of the Admin Console
        cy.get('div[id="user-dropdown"]').contains('admin').click()
        cy.get('a').contains('Sign out').click()

        // verify that logged out
        cy.url().should('include', '/auth/realms/master/protocol/openid-connect/auth?')
    })

    // After the testing is complete we should take down the created testing environment
    after(() => {

        // Use the properties fixture for configuring the admin username and password
        cy.fixture('properties.json').then((properties) => {

            // defined from fixture
            const username = properties.admin.username;
            const password = properties.admin.password;

            cy.visit('https://'+properties.admin.hostname+'/auth/admin/master/console')

            // Assert that location is the login page
            cy.url().should('include', '/auth/realms/master/protocol/openid-connect/auth?')

            // Enter Admin Username and Assert it was entered correctly
            cy.get('input[id="username"]').type(username)
            cy.get('input[id="username"]').should('have.value', username)

            // Enter Admin Password and Assert it was entered correctly
            cy.get('input[id="password"]').type(password)
            cy.get('input[id="password"]').should('have.value', password)
    
            // Click the submit login button on the login page and assert
            // that the new location is the signed in admin console page
            cy.get('input[id="kc-login"]').click()
            cy.url().should('eq', 'https://'+properties.admin.hostname+'/auth/admin/master/console/')
        })

        // Toggle the sidebar menu to be open
        cy.get('button[id="nav-toggle"]').click()
        cy.get('div[id="page-sidebar"]').should('have.class', 'pf-m-expanded')

        // Click the Realm Selection Drop Down
        cy.get('div[id="realm-select"]').contains('master').click()
        cy.get('div[id="realm-select"]').should('have.class', 'pf-m-expanded')
        
        // Select the Testing Realm to be removed
        cy.get('div').contains('cypress-testing').click()

        // Select the Realm Settings option
        cy.get('a').contains('Realm settings').click()

        // Toggle the sidebar menu to be closed
        cy.get('button[id="nav-toggle"]').click()
        cy.get('div[id="page-sidebar"]').should('have.class', 'pf-m-collapsed')

        // Select the Realm Settings Action DropDown
        cy.get('div[data-testid="action-dropdown"]').contains('Action').click()

        // Delete the Testing Realm
        cy.get('a').contains('Delete').click()

        // Confirm the Deletion
        cy.get('button[id="modal-confirm"]').contains('Delete').click()
        cy.url().should('include', '/auth/admin/master')

        // Toggle the sidebar menu to be open
        cy.get('button[id="nav-toggle"]').click()
        cy.get('div[id="page-sidebar"]').should('have.class', 'pf-m-expanded')

        // Click the Realm Selection Drop Down
        cy.get('div[id="realm-select"]').contains('master').click()
        cy.get('div[id="realm-select"]').should('have.class', 'pf-m-expanded')

        // Verify that the Testing Realm doesnt exist
        cy.get('div').contains('cypress-testing').should('not.exist')

        // Logout of the Admin Console
        cy.get('div[id="user-dropdown"]').contains('admin').click()
        cy.get('a').contains('Sign out').click()

        // verify that logged out
        cy.url().should('include', '/auth/realms/master/protocol/openid-connect/auth?')
    })

    it('User Login', () => {
        // Go to Keycloak Authentication Testing Webapp
        cy.visit('https://keycloak.org/app')

        // Due to changing URLs, need to encapsulate commands inside of the origin
        cy.origin('https://www.keycloak.org', () => {
            // Use the properties fixture for configuring the admin username and password
            cy.fixture('properties.json').then((properties) => {

                const hostname = properties.admin.hostname;

                // Clear and Enter Keycloak information for Authentication
                cy.get('input[id="url"]').clear().type('https://'+hostname+'/auth')
                cy.get('input[id="realm"]').clear().type(properties.realm)
                cy.get('input[id="client"]').clear().type(properties.client)

                // Save configuration and assert URL is correct
                cy.get('button').contains('Save').click()
                cy.url().should('include', 'https://'+hostname+'/auth&realm='+properties.realm+'&client='+properties.client+'')

                // Click on the Sign in button to initiate User Login and assert on the keycloak login page
                cy.get('a[id="login"]').contains('Sign in').click()
            })
        })

        cy.get('header').contains('Sign in to your account')
        cy.fixture('properties.json').then((properties) => {
            // Enter Users Credentials and assert they are entered correcrtly 
            cy.get('input[id="username"]').type(properties.user.username)
            cy.get('input[id="password"]').type(properties.user.password)

            // Click Sign In to Authenticate User and assert that the terms and conditions prompt is displayed
            cy.get('input[id="kc-login"]').click()
            cy.url().should('include', '/auth/realms/'+properties.realm+'/login-actions/required-action?execution=TERMS_AND_CONDITIONS')
            cy.get('header').contains('Terms and Conditions')

            // Accept the terms and conditions and assert that the MFA is then prompted
            cy.get('input[id="kc-accept"]').contains('Accept').click()
            cy.url().should('include', '/auth/realms/'+properties.realm+'/login-actions/required-action?execution=CONFIGURE_TOTP')
            cy.get('header').contains('Mobile Authenticator Setup')
        })
    })
})