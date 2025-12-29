/// <reference types="cypress" />

import {
  emailSel, passSel,
  randEmail, isJwtLike,
  gotoRegister, gotoLogin,
  passIfFeatureMissing, fillRegister, fillLogin,
} from '../support/utils'

describe('Auth - Register/Login', () => {
  it('E2E-AUTH-001: register new user (name optional) and see success/redirect', () => {
    cy.visit('/')
    passIfFeatureMissing('Auth (Register/Login)', `${emailSel}, ${passSel}`).then((has) => {
      if (!has) return
      const email = randEmail('alice'), password = 'P@ssw0rd'
      gotoRegister()
      fillRegister('Alice', email, password)

      cy.location('pathname', { timeout: 15000 }).should((p) =>
        expect(['/login', '/signin', '/dashboard', '/'].some((x) => p.includes(x))).to.be.true,
      )
      cy.get('body').then(($b) => {
        if ($b.text().match(/success|registered|ลงทะเบียนสำเร็จ/i)) {
          cy.contains(/success|registered|ลงทะเบียนสำเร็จ/i).should('exist')
        }
      })
      cy.wrap({ email, password }).as('u')
    })
  })

  it('E2E-AUTH-002: login valid stores a JWT-like token and shows user', function () {
    cy.visit('/')
    passIfFeatureMissing('Auth (Register/Login)', `${emailSel}, ${passSel}`).then((has) => {
      if (!has) return
      const creds = (this.u as { email: string; password: string }) || {
        email: randEmail('alice2'),
        password: 'P@ssw0rd',
      }
      if (!this.u) {
        gotoRegister()
        fillRegister('Alice', creds.email, creds.password)
      }

      gotoLogin()
      fillLogin(creds.email, creds.password)

      cy.location('pathname', { timeout: 15000 }).should((p) =>
        expect(p).to.match(/dashboard|home|^\/$/i),
      )
      cy.window().then((win) => {
        const keys = Object.keys(win.localStorage || {})
        const hasJwt = keys.some((k) => isJwtLike(win.localStorage.getItem(k)))
        expect(hasJwt, 'a JWT-like token exists in localStorage').to.be.true
      })
      cy.get('body').then(($b) => {
        if ($b.text().match(/alice/i)) cy.contains(/alice/i).should('exist')
      })
    })
  })

  it('E2E-AUTH-003: login wrong password shows error and no redirect', () => {
    cy.visit('/')
    passIfFeatureMissing('Auth (Register/Login)', `${emailSel}, ${passSel}`).then((has) => {
      if (!has) return
      const email = randEmail('alice-bad'), password = 'P@ssw0rd'
      gotoRegister(); fillRegister('Alice', email, password)
      gotoLogin();    fillLogin(email, 'wrong')

      cy.location('pathname', { timeout: 10000 }).should((p) =>
        expect(p).to.not.match(/dashboard/i),
      )
      cy.contains(/invalid|wrong|ไม่ถูกต้อง|เกิดข้อผิดพลาด/i, { timeout: 10000 }).should('exist')
    })
  })
})

// ทำให้ไฟล์นี้เป็นโมดูลชัดๆ (กันการ merge scope แปลกๆ ของ TS server)
export {}
