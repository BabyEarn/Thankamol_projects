/// <reference types="cypress" />

describe('Smoke - Home & API health', () => {
  it('loads home page and shows brand text', () => {
    cy.visit('/')

    // ✅ รอให้ SPA mount ที่ #app
    cy.get('#app', { timeout: 15000 }).should('exist')

    // ✅ ยอมรับทั้ง GPSplit หรือ GADYPADIE
    cy.contains(/(gpsplit|gadypadie)/i, { timeout: 15000 }).should('exist')

    // ✅ กันเหนียว: ตรวจ document.title
    cy.title().should('match', /(gadypadie|gpsplit)/i)
  })
})
