// Cypress tests for validating the user login process
describe('User Login Tests', () => {

    // To be able to test a user we need to have an environment
    // that is configured for testing, this means a realm, client
    // and a defined user.
    it('SETUP', () => {

        cy.visit('https://keycloak.bigbang.dev/auth/admin/master/console')
        // Assert that location is the login page
        cy.url().should('include', '/auth/realms/master/protocol/openid-connect/auth?')

        // Use the admin_login fixture for configuring the admin username and password
        cy.fixture('admin_login.json').then((login) => {
            // defined from fixture
            const username = login.admin_username;
            const password = login.admin_password;

            // Enter Admin Username and Assert it was entered correctly
            cy.get('input[id="username"]').type(username)
            cy.get('input[id="username"]').should('have.value', username)

            // Enter Admin Password and Assert it was entered correctly
            cy.get('input[id="password"]').type(password)
            cy.get('input[id="password"]').should('have.value', password)
    
        })

        // Click the submit login button on the login page and assert
        // that the new location is the signed in admin console page
        cy.get('input[id="kc-login"]').click()
        cy.url().should('eq', 'https://keycloak.bigbang.dev/auth/admin/master/console/')
    
        // LOGGED INTO THE ADMIN CONSOLE, NEED TO ADD CLIENT FOR TESTING

        // Toggle the sidebar menu to be open
        cy.get('button[id="nav-toggle"]').click()
        cy.get('div[id="page-sidebar"]').should('have.class', 'pf-m-expanded')

        // Click the Realm Drop Down
        cy.get('button[id="pf-dropdown-toggle-id-13"]').click()
        cy.get('div[id="realm-select"]').should('have.class', 'pf-m-expanded')

        // Click the baby-yoda realm
        cy.get('div').contains('baby-yoda').click()
        cy.url().should('include', '/auth/admin/master/console/#/baby-yoda')

        // Click the Clients option from menu
        cy.get('a').contains('Clients').click()
        cy.url().should('include', '/auth/admin/master/console/#/baby-yoda/clients')

        // Toggle the sidebar menu to be closed
        cy.get('button[id="nav-toggle"]').click()
        cy.get('div[id="page-sidebar"]').should('have.class', 'pf-m-collapsed')

        // Click the testing client from Clients
        cy.get('a').contains('dev_00eb8904-5b88-4c68-ad67-cec0d2e07aa6_testingclient').click()
        cy.url().should('include', '/baby-yoda/clients/aae1ba61-79b1-415d-81d5-18f55d92fb82/settings')

    })

})