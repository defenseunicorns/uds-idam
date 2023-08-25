// Commands that will be run for all spec files and all tests. 
// Can also add or overwrite Cypress commands for ease of use throughout spec files.

// If one test fails then we want to stop running all subsequent tests
// afterEach(function() {
//     if (this.currentTest.state === 'failed') {
//         Cypress.runner.stop();
//     }
// });