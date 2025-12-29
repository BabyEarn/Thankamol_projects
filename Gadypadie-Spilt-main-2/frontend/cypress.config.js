// frontend/cypress.config.js

module.exports = {
    e2e: {
        baseUrl: "http://localhost:5173", // ถ้า Vite ใช้ port อื่น เปลี่ยนเลขตรงนี้
        specPattern: "cypress/e2e/**/*.cy.{js,ts}",
        supportFile: "cypress/support/e2e.ts",
        setupNodeEvents(on, config) {
            // ยังไม่ใช้ plugin พิเศษอะไร ก็คืน config เฉย ๆ
            return config;
        },
    },
};
