// Cypress tests for validating the admin login process
describe('Admin Login Tests', () => {

    // Assert that we can reach the admin console
    it('Verify Keycloak Admin Console is Reachable', () => {
        cy.fixture('properties.json').then((properties) => {
            // Navigate to Keycloak Admin Console
            cy.visit('https://'+properties.admin.hostname+'/auth/admin/master/console')
            // Assert that location is the login page
            cy.url().should('include', '/auth/realms/master/protocol/openid-connect/auth?')
        })
    })

    // Attempt to Login as the Admin user to the Admin Console
    it('Successfully Login', () => {      
        // Use the properties fixture for configuring the admin username and password
        cy.fixture('properties.json').then((properties) => {
            // Navigate to Keycloak Admin Console
            cy.visit('https://'+properties.admin.hostname+'/auth/admin/master/console')

            // defined from fixture
            const username = properties.admin.username;
            const password = properties.admin.password;

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

        // Also for further verification login success check that the
        // correct cookies are created
        cy.getCookie("AUTH_SESSION_ID").should('exist')
        cy.getCookie("KEYCLOAK_IDENTITY").should('exist')
        cy.getCookie("KEYCLOAK_SESSION").should('exist')
    })

    // Attempt to Login to the Admin Console with invalid Credentials
    it('Invalid Credential Login', () => {
        // Use the properties fixture for configuring the admin username
        cy.fixture('properties.json').then((properties) => {
            // Navigate to Keycloak Admin Console
            cy.visit('https://'+properties.admin.hostname+'/auth/admin/master/console')

            // defined from fixture
            const username = properties.admin.username;

            // Enter Admin Username and Assert it was entered correctly
            cy.get('input[id="username"]').type(username)
            cy.get('input[id="username"]').should('have.value', username)

            // Enter Admin Password and Assert it was entered correctly
            cy.get('input[id="password"]').type("not-the-password")
            cy.get('input[id="password"]').should('have.value', "not-the-password")
    
        })
  
        // Click the submit login button on the login page and assert
        // that the popup is present for incorrect credentials
        cy.get('input[id="kc-login"]').click()
        cy.get('span[id="input-error"]').should('exist')
    })
  })