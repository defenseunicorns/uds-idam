// Cypress tests for validating the admin login process
describe('Admin Login Tests', () => {

    // Before each test go to the keycloak admin console page
    // to start the login process
    beforeEach(() => {
        // Navigate to Keycloak Admin Console
        cy.visit('https://keycloak.bigbang.dev/auth/admin/master/console')
    })

    it('Verify Keycloak Admin Console is Reachable', () => {
        // Assert that location is the login page
        cy.url().should('include', '/auth/realms/master/protocol/openid-connect/auth?')
    })

    it('Successfully Login', () => {      
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
    
        // Also for further verification login success check that the
        // correct cookies are created
        cy.getCookie("AUTH_SESSION_ID").should('exist')
        cy.getCookie("KEYCLOAK_IDENTITY").should('exist')
        cy.getCookie("KEYCLOAK_SESSION").should('exist')
    })

    it('Invalid Credential Login', () => {
        // Use the admin_login fixture for configuring the admin username
        cy.fixture('admin_login.json').then((login) => {
            // defined from fixture
            const username = login.admin_username;

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