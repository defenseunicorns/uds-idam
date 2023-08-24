// Basic example of a cypress tests based on cypress website examples
// https://docs.cypress.io/guides/end-to-end-testing/writing-your-first-end-to-end-test


// Visit a webpage and asserts its in the right place
// then adds some data to a field on that page and asserts that data is used correctly
describe('Example Cypress Test', () => {
  it('Visits the Cypress Website', () => {
    cy.visit('https://example.cypress.io')

    // navigate to the Type description page
    cy.contains('type').click()
    
    // make sure on the right page after clicking on new page
    cy.url().should('include', 'commands/actions')

    // add an email to field
    cy.get('.action-email').type('test@gmail.com')
    
    // verify that email field is populated as expected
    cy.get('.action-email').should('have.value', 'test@gmail.com')

    // alternatively we can combine the two commands
    // cy.get('.action-email').type('test@gmail.com').should('have.value', 'test@gmail.com')
  })
})




// Using a fixture is a great way to create a configuration file for testing purposes
// in the cypress/fixture/ directory we can add as many fixtures as necessary
// this is an example of the earlier test using a fixture instead of hard coded test values
describe('Example Cypress Test With Fixture', () => {
  it('Visits the Cypress Website', () => {
    cy.visit('https://example.cypress.io')

    // navigate to the Type description page
    cy.contains('type').click()
    
    // make sure on the right page after clicking on new page
    cy.url().should('include', 'commands/actions')

    // use static data from fixture/example.json
    cy.fixture('example.json').then((example) => {

      // define email from fixture
      const email = example.email;

      // apply and assert that the email used properly 
      cy.get('.action-email').type(email);
      cy.get('.action-email').should('have.value', email);
    })
  })
})