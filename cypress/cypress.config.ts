const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    supportFile: 'support/e2e.ts',
    specPattern: 'e2e/**/*.cy.ts',
    fixturesFolder: 'fixtures/',
    video: false,
    screenshotOnRunFailure: false,
  },
});
