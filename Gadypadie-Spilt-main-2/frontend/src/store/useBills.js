// frontend/src/store/useBills.js
import axios from 'axios'

const api = axios.create({
    baseURL: import.meta.env.VITE_API_BASE || '/api',
})

// ---------------------- Demo store (fallback ถ้า backend ล่ม) ----------------------

const DEMO_KEY = 'gps_demo_bills_v2'
const DEMO_RATES_KEY = 'gps_demo_rates_v2'

function loadDemoBills() {
    try {
        const raw = localStorage.getItem(DEMO_KEY)
        if (!raw) return []
        return JSON.parse(raw)
    } catch {
        return []
    }
}

function saveDemoBills(bills) {
    localStorage.setItem(DEMO_KEY, JSON.stringify(bills))
}

function loadRates() {
    try {
        const raw = localStorage.getItem(DEMO_RATES_KEY)
        if (!raw) {
            const def = { THB: 1, USD: 35, EUR: 38 }
            localStorage.setItem(DEMO_RATES_KEY, JSON.stringify(def))
            return def
        }
        return JSON.parse(raw)
    } catch {
        return { THB: 1 }
    }
}

function saveRates(r) {
    localStorage.setItem(DEMO_RATES_KEY, JSON.stringify(r))
}

let demoBills = loadDemoBills()
let rates = loadRates()

export function getRates() {
    return rates
}

export function setRatesFromCsv(csv) {
    const lines = csv.split('\n').map(l => l.trim()).filter(Boolean)
    const map = {}
    for (const line of lines) {
        const [code, value] = line.split(',')
        if (!code || !value) continue
        const v = Number(value)
        if (!isNaN(v) && v > 0) {
            map[code.trim().toUpperCase()] = v
        }
    }
    if (!map.THB) map.THB = 1
    rates = map
    saveRates(rates)
    return rates
}

export function getDemoGroups() {
    return [
        { name: 'Group A', members: ['Alice', 'Bob', 'Charlie', 'Diana'] },
        { name: 'Friday Night Gang', members: ['Mint', 'Beam', 'Earn', 'Best'] },
    ]
}

// ---------------------- Bills API ----------------------

export async function fetchBills() {
    try {
        const res = await api.get('/bills')
        return res.data || []
    } catch (e) {
        // fallback demo
        demoBills = loadDemoBills()
        return demoBills
    }
}

export async function fetchBill(id) {
    try {
        const res = await api.get(`/bills/${id}`)
        return res.data
    } catch (e) {
        demoBills = loadDemoBills()
        return demoBills.find(b => String(b.id) === String(id)) || null
    }
}

export async function createBill(title) {
    const payload = {
        title: title && title.trim() ? title.trim() : 'Untitled bill',
        baseCurrency: 'THB',
        recurring: false,
        recurringKey: null,
    }

    try {
        const res = await api.post('/bills', payload)
        const bill = res.data
        // backend คืน object ที่มี id → เอาไปใช้ต่อได้เลย
        return bill
    } catch (e) {
        // demo fallback
        demoBills = loadDemoBills()
        const newId = demoBills.length ? Math.max(...demoBills.map(b => Number(b.id))) + 1 : 1
        const bill = {
            id: newId,
            title: payload.title,
            baseCurrency: 'THB',
            members: [],
            expenses: [],
            payments: [],
            createdAt: Date.now(),
        }
        demoBills.push(bill)
        saveDemoBills(demoBills)
        return bill
    }
}

export async function deleteBill(id) {
    try {
        await api.delete(`/bills/${id}`)
    } catch (e) {
        demoBills = loadDemoBills()
        demoBills = demoBills.filter(b => String(b.id) !== String(id))
        saveDemoBills(demoBills)
    }
}

export async function addMember(billId, name) {
    if (!name) return
    try {
        await api.post(`/bills/${billId}/members`, { name })
    } catch (e) {
        demoBills = loadDemoBills()
        const bill = demoBills.find(b => String(b.id) === String(billId))
        if (!bill) return
        bill.members = bill.members || []
        if (!bill.members.includes(name)) bill.members.push(name)
        saveDemoBills(demoBills)
    }
}

export async function addGroupMembers(billId, groupName) {
    const group = getDemoGroups().find(g => g.name === groupName)
    if (!group) return
    for (const m of group.members) {
        // call addMember ทีละคน (demo / backend)
        // eslint-disable-next-line no-await-in-loop
        await addMember(billId, m)
    }
}

export async function addExpense(billId, payload) {
    const safe = { ...payload }

    // คำนวณ amountBase ตาม rate
    const rate = rates[safe.currency] || 1
    safe.amount = Number(safe.amount || 0)
    safe.amountBase = Number((safe.amount * rate).toFixed(2))

    try {
        await api.post(`/bills/${billId}/expenses`, {
            description: safe.description,
            payer: safe.payer,
            currency: safe.currency,
            amount: safe.amount,
            amountBase: safe.amountBase,
            splitMode: safe.splitMode,
            receiptUrl: safe.receiptUrl,
            voiceUrl: safe.voiceUrl,
            participants: safe.participants || [],
        })
    } catch (e) {
        demoBills = loadDemoBills()
        const bill = demoBills.find(b => String(b.id) === String(billId))
        if (!bill) return
        bill.expenses = bill.expenses || []
        const newId = bill.expenses.length ? Math.max(...bill.expenses.map(ex => Number(ex.id))) + 1 : 1
        bill.expenses.push({
            id: newId,
            description: safe.description,
            payer: safe.payer,
            participants: safe.participants || [],
            currency: safe.currency,
            amount: safe.amount,
            amountBase: safe.amountBase,
            splitMode: safe.splitMode,
            receiptUrl: safe.receiptUrl,
            voiceUrl: safe.voiceUrl,
            createdAt: Date.now(),
        })
        saveDemoBills(demoBills)
    }
}

// ✅ ฟังก์ชันนี้ตัวเดิม แต่เติมบอดี้ให้ครบ
export async function clearExpenses(billId) {
    if (!billId) return
    try {
        await api.post(`/bills/${billId}/clear`)
    } catch (e) {
        demoBills = loadDemoBills()
        const bill = demoBills.find(b => String(b.id) === String(billId))
        if (!bill) return
        bill.expenses = []
        bill.payments = []
        saveDemoBills(demoBills)
    }
}

export async function updateExpense(billId, expenseId, payload) {
    if (!billId || expenseId == null) return
    const safe = { ...payload }
    const rate = rates[safe.currency] || 1
    safe.amount = Number(safe.amount || 0)
    safe.amountBase = Number((safe.amount * rate).toFixed(2))

    try {
        await api.put(`/bills/${billId}/expenses/${expenseId}`, {
            description: safe.description,
            payer: safe.payer,
            currency: safe.currency,
            amount: safe.amount,
            amountBase: safe.amountBase,
            splitMode: safe.splitMode,
            receiptUrl: safe.receiptUrl,
            voiceUrl: safe.voiceUrl,
            participants: safe.participants || [],
        })
    } catch (e) {
        demoBills = loadDemoBills()
        const bill = demoBills.find(b => String(b.id) === String(billId))
        if (!bill || !bill.expenses) return
        const ex = bill.expenses.find(ex => String(ex.id) === String(expenseId))
        if (!ex) return
        ex.description = safe.description
        ex.payer = safe.payer
        ex.currency = safe.currency
        ex.amount = safe.amount
        ex.amountBase = safe.amountBase
        ex.splitMode = safe.splitMode
        ex.receiptUrl = safe.receiptUrl
        ex.voiceUrl = safe.voiceUrl
        ex.participants = safe.participants || []
        saveDemoBills(demoBills)
    }
}

export async function deleteExpense(billId, expenseId) {
    if (!billId || expenseId == null) return
    try {
        await api.delete(`/bills/${billId}/expenses/${expenseId}`)
    } catch (e) {
        demoBills = loadDemoBills()
        const bill = demoBills.find(b => String(b.id) === String(billId))
        if (!bill || !bill.expenses) return
        bill.expenses = bill.expenses.filter(ex => String(ex.id) !== String(expenseId))
        saveDemoBills(demoBills)
    }
}

// payments / smart settlement history
export async function markPaid(billId, payload) {
    try {
        await api.post(`/bills/${billId}/payments`, {
            from: payload.from,
            to: payload.to,
            amount: Number(payload.amount || 0),
            method: payload.method || 'PROMPTPAY',
            referenceCode: payload.referenceCode || null,
            payslipUrl: payload.payslipUrl || null,
        })
    } catch (e) {
        demoBills = loadDemoBills()
        const bill = demoBills.find(b => String(b.id) === String(billId))
        if (!bill) return
        bill.payments = bill.payments || []
        bill.payments.push({
            id: bill.payments.length + 1,
            fromMember: payload.from,
            toMember: payload.to,
            amount: Number(payload.amount || 0),
            method: payload.method || 'PROMPTPAY',
            referenceCode: payload.referenceCode || null,
            payslipUrl: payload.payslipUrl || null,
            createdAt: Date.now(),
        })
        saveDemoBills(demoBills)
    }
}

export async function getPayments(billId) {
    try {
        const res = await api.get(`/bills/${billId}/payments`)
        return res.data || []
    } catch (e) {
        demoBills = loadDemoBills()
        const bill = demoBills.find(b => String(b.id) === String(billId))
        return bill?.payments || []
    }
}

// ---------------------- Smart settlement (ใช้ฝั่ง frontend) ----------------------

export function getSummary(bill) {
    if (!bill) return { total: 0, perMember: [], transfers: [], balance: {} }

    const members = bill.members || []
    const expenses = bill.expenses || []

    const balances = {}
    const paidMap = {}
    const mustPayMap = {}

    members.forEach((m) => {
        balances[m] = 0
        paidMap[m] = 0
        mustPayMap[m] = 0
    })

    let total = 0

    for (const ex of expenses) {
        const participants =
            ex.participants && ex.participants.length ? ex.participants : members
        if (!participants.length) continue

        const amtBase = ex.amountBase ?? ex.amount ?? 0
        const per = amtBase / participants.length
        total += amtBase

        // คนที่เป็น payer → จ่ายไปเท่าไหร่
        if (ex.payer) {
            if (balances[ex.payer] === undefined) {
                balances[ex.payer] = 0
                paidMap[ex.payer] = 0
                mustPayMap[ex.payer] = 0
            }
            balances[ex.payer] += amtBase
            paidMap[ex.payer] += amtBase
        }

        // คนที่ร่วมจ่ายใน expense นี้ → ควรจ่ายเท่าไหร่
        for (const p of participants) {
            if (balances[p] === undefined) {
                balances[p] = 0
                paidMap[p] = 0
                mustPayMap[p] = 0
            }
            balances[p] -= per
            mustPayMap[p] += per
        }
    }

    const perMember = members.map((m) => ({
        name: m,
        // จ่ายไปจริงเท่าไหร่
        paidFirst: Number((paidMap[m] || 0).toFixed(2)),
        // ควรจ่ายตามส่วนแบ่งเท่าไหร่
        mustPay: Number((mustPayMap[m] || 0).toFixed(2)),
        // net > 0 = ควร “รับเงินเพิ่ม”, net < 0 = ควร “จ่ายเพิ่ม”
        getMore: Number((balances[m] || 0).toFixed(2)),
    }))

    const debtors = []
    const creditors = []
    for (const [name, bal] of Object.entries(balances)) {
        const rounded = Number(bal.toFixed(2))
        if (rounded > 0.01) creditors.push({ name, amount: rounded })
        else if (rounded < -0.01) debtors.push({ name, amount: -rounded })
    }

    const transfers = []
    let i = 0
    let j = 0
    while (i < debtors.length && j < creditors.length) {
        const d = debtors[i]
        const c = creditors[j]
        const pay = Math.min(d.amount, c.amount)
        transfers.push({
            from: d.name,
            to: c.name,
            amount: Number(pay.toFixed(2)),
        })
        d.amount -= pay
        c.amount -= pay
        if (d.amount <= 0.01) i++
        if (c.amount <= 0.01) j++
    }

    return {
        total: Number(total.toFixed(2)),
        perMember,
        transfers,
        balance: balances,
    }

}
