import { defineConfig } from "cypress";

export default defineConfig({
  e2e: {
    retries: 3,
    supportFile: 'support/e2e.ts',
    specPattern: 'e2e/**/*.cy.ts',
    fixturesFolder: 'fixtures/',
    video: false,
    screenshotOnRunFailure: false,
  },
});
