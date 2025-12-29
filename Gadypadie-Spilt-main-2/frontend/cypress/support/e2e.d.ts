/// <reference types="cypress" />
declare global {
  namespace Cypress {
    interface Chainable {
      // ช่วยให้ VS Code รับ RegExp คู่กับ selector ได้สบายใจขึ้น
      contains(
        selector: string,
        content: string | number | RegExp,
        options?: Partial<Loggable & Timeoutable & CaseMatchable>
      ): Chainable<JQuery<HTMLElement>>;
    }
  }
}
export {};
