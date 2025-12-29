<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  fetchBill,
  addMember,
  addGroupMembers,
  clearExpenses,
  getSummary,
  getDemoGroups,
  getRates,
  markPaid,
  getPayments,
  updateExpense,
  deleteExpense,
} from '../store/useBills'
import ModalAddExpense from '../components/ModalAddExpense.vue'
import jsPDF from 'jspdf'

const route = useRoute()
const router = useRouter()
const id = route.params.id

const bill = ref(null)
const loading = ref(false)
const activeTab = ref('members')
const newMember = ref('')
const groups = ref(getDemoGroups())
const selectedGroup = ref('')
const summary = ref(null)
const showAddExpense = ref(false)
const editingExpense = ref(null)
const payments = ref([])
const rates = ref(getRates())

// -------- Smart Settlement & PromptPay --------
const PROMPTPAY_NUMBER = '0812345678' // demo

const qrTransfer = ref(null)
const promptpayQrUrl = computed(() => {
  if (!qrTransfer.value) return ''
  const amt = qrTransfer.value.amount.toFixed(2)
  return `https://promptpay.io/${PROMPTPAY_NUMBER}/${amt}`
})

// modal บันทึกการจ่าย + payslip
const showPaymentModal = ref(false)
const paymentTarget = ref(null)
const paymentMethod = ref('PROMPTPAY')
const paymentRef = ref('')
const paymentPayslipFile = ref(null)
const paymentPayslipPreview = ref(null)

// -------- Group History filters --------
const historyFrom = ref('')
const historyTo = ref('')
const historyMember = ref('all')

const filteredHistoryPayments = computed(() => {
  let list = payments.value ? [...payments.value] : []

  // sort ล่าสุดขึ้นก่อน
  list.sort((a, b) => {
    const ta = a.createdAt ? new Date(a.createdAt).getTime() : 0
    const tb = b.createdAt ? new Date(b.createdAt).getTime() : 0
    return tb - ta
  })

  const fromTime = historyFrom.value
      ? new Date(historyFrom.value).setHours(0, 0, 0, 0)
      : null
  const toTime = historyTo.value
      ? new Date(historyTo.value).setHours(23, 59, 59, 999)
      : null
  const member = historyMember.value

  return list.filter((p) => {
    const t = p.createdAt ? new Date(p.createdAt).getTime() : null

    if (fromTime && (!t || t < fromTime)) return false
    if (toTime && (!t || t > toTime)) return false

    if (member && member !== 'all') {
      if (p.from !== member && p.to !== member) return false
    }
    return true
  })
})

async function load() {
  loading.value = true
  try {
    const data = await fetchBill(id)
    bill.value = data || {
      id,
      title: 'Untitled bill',
      members: [],
      expenses: [],
      createdAt: Date.now(),
      payments: [],
    }
    summary.value = getSummary(bill.value)
    payments.value = await getPayments(id)
  } finally {
    loading.value = false
  }
}

onMounted(load)

const totalBase = computed(() => summary.value?.total ?? 0)

function memberBalanceClass(v) {
  if (v > 0.01) return 'positive'
  if (v < -0.01) return 'negative'
  return ''
}

async function addNewMember() {
  if (!newMember.value.trim()) return
  await addMember(id, newMember.value.trim())
  newMember.value = ''
  await load()
}

async function addSelectedGroup() {
  if (!selectedGroup.value) return
  await addGroupMembers(id, selectedGroup.value)
  selectedGroup.value = ''
  await load()
}

// ---------- Expense modal ----------
function openAddExpense(ex = null) {
  editingExpense.value = ex
  showAddExpense.value = true
}

async function onExpenseSaved() {
  await load()
  editingExpense.value = null
}

async function deleteExpenseRow(ex) {
  if (!ex || ex.id == null) return
  const ok = confirm('Delete this expense?')
  if (!ok) return
  await deleteExpense(id, ex.id)
  await load()
}

async function resetExpenses() {
  const ok = confirm('Clear all expenses in this bill?')
  if (!ok) return
  await clearExpenses(id)
  await load()
}

// ---------- Smart Settlement: PromptPay QR ----------
function openQr(t) {
  qrTransfer.value = t
}

function closeQr() {
  qrTransfer.value = null
}

// ---------- Smart Settlement: Mark paid + payslip ----------
function openPaymentModal(t) {
  paymentTarget.value = t
  paymentMethod.value = 'PROMPTPAY'
  paymentRef.value = ''
  paymentPayslipFile.value = null
  paymentPayslipPreview.value = null
  showPaymentModal.value = true
}

function onPayslipChange(e) {
  const file = e.target.files && e.target.files[0]
  paymentPayslipFile.value = file || null
  paymentPayslipPreview.value = file ? URL.createObjectURL(file) : null
}

function removePayslip() {
  paymentPayslipFile.value = null
  paymentPayslipPreview.value = null
}

async function savePayment() {
  if (!paymentTarget.value) return
  const payload = {
    from: paymentTarget.value.from,
    to: paymentTarget.value.to,
    amount: paymentTarget.value.amount,
    method: paymentMethod.value || 'PROMPTPAY',
    referenceCode: paymentRef.value || null,
    payslipUrl: paymentPayslipPreview.value || null,
  }
  await markPaid(id, payload)
  showPaymentModal.value = false
  paymentTarget.value = null
  await load()
}

// ---------- Export PDF ----------
function exportPdf() {
  if (!bill.value || !summary.value) return
  const doc = new jsPDF()
  let y = 20

  doc.setFontSize(16)
  doc.text(`Bill: ${bill.value.title || bill.value.id}`, 10, y)
  y += 8
  doc.setFontSize(11)
  doc.text(`Bill ID: ${bill.value.id}`, 10, y)
  y += 6
  doc.text(`Members: ${(bill.value.members || []).join(', ')}`, 10, y)
  y += 8
  doc.text(`Total (base currency): ${summary.value.total.toFixed(2)}`, 10, y)
  y += 10

  doc.setFontSize(13)
  doc.text('Per member', 10, y)
  y += 6
  doc.setFontSize(10)

  summary.value.perMember.forEach((pm) => {
    doc.text(
        `${pm.name}  paid=${pm.paidFirst.toFixed(2)}  shouldPay=${pm.mustPay.toFixed(
            2,
        )}  net=${pm.getMore.toFixed(2)}`,
        10,
        y,
    )
    y += 5
  })

  y += 6
  doc.setFontSize(13)
  doc.text('Smart settlement', 10, y)
  y += 6
  doc.setFontSize(10)

  if (!summary.value.transfers.length) {
    doc.text('All settled (no transfers needed).', 10, y)
  } else {
    summary.value.transfers.forEach((t) => {
      doc.text(`${t.from} → ${t.to}: ${t.amount.toFixed(2)}`, 10, y)
      y += 5
    })
  }

  doc.save(`bill-${bill.value.id}-summary.pdf`)
}
</script>

<template>
  <div class="page">
    <div class="p24" v-if="bill">
      <div class="flex-between">
        <div>
          <div class="h1">
            {{ bill.title || 'Untitled bill' }}
          </div>
          <div class="helper">
            Bill ID: {{ bill.id }}
          </div>
        </div>
        <div class="flex gap8">
          <button class="btn-outline" @click="router.push('/')">
            Back
          </button>
          <button class="btn" @click="openAddExpense()">
            Add expense
          </button>
          <button class="btn-outline" @click="exportPdf">
            Export PDF
          </button>
        </div>
      </div>

      <div class="mt16">
        <div class="tabs">
          <button
              class="tab"
              :class="{ active: activeTab === 'members' }"
              @click="activeTab = 'members'"
          >
            Members
          </button>
          <button
              class="tab"
              :class="{ active: activeTab === 'expenses' }"
              @click="activeTab = 'expenses'"
          >
            Expenses
          </button>
          <button
              class="tab"
              :class="{ active: activeTab === 'summary' }"
              @click="activeTab = 'summary'"
          >
            Summary
          </button>
          <button
              class="tab"
              :class="{ active: activeTab === 'history' }"
              @click="activeTab = 'history'"
          >
            History
          </button>
        </div>
      </div>

      <!-- Members tab -->
      <div v-if="activeTab === 'members'" class="mt16 card p24">
        <div class="h2">Members</div>
        <div class="mt12 flex gap8">
          <input
              v-model="newMember"
              class="input"
              placeholder="Add member"
              style="max-width:260px"
          />
          <button class="btn" @click="addNewMember">
            Add
          </button>
        </div>

        <div class="mt16 flex gap8 wrap">
          <div>
            <div class="helper mb4">Add from group</div>
            <select v-model="selectedGroup" class="input">
              <option value="">-- choose group --</option>
              <option
                  v-for="g in groups"
                  :key="g.name"
                  :value="g.name"
              >
                {{ g.name }} ({{ g.members.length }} people)
              </option>
            </select>
          </div>
          <div class="flex align-end">
            <button
                class="btn-outline"
                :disabled="!selectedGroup"
                @click="addSelectedGroup"
            >
              Add group members
            </button>
          </div>
        </div>

        <div class="mt16">
          <div class="helper">Current members:</div>
          <div class="mt8 flex gap8 wrap">
            <span
                v-for="m in bill.members"
                :key="m"
                class="chip"
            >
              {{ m }}
            </span>
            <span v-if="!bill.members?.length" class="helper">
              No members yet.
            </span>
          </div>
        </div>
      </div>

      <!-- Expenses tab -->
      <div v-if="activeTab === 'expenses'" class="mt16 card p24">
        <div class="flex-between">
          <div class="h2">Expenses</div>
          <button class="btn-danger-outline" @click="resetExpenses">
            Clear all expenses
          </button>
        </div>
        <div v-if="!bill.expenses?.length" class="mt12 helper">
          No expenses yet. Click "Add expense".
        </div>
        <table v-else class="mt12 expenses-table">
          <thead>
          <tr>
            <th>Description</th>
            <th>Payer</th>
            <th>Participants</th>
            <th>Amount</th>
            <th>Receipt / Voice</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <tr v-for="ex in bill.expenses" :key="ex.id">
            <td>{{ ex.description }}</td>
            <td>{{ ex.payer || '-' }}</td>
            <td>
                <span
                    v-for="m in ex.participants"
                    :key="m"
                    class="chip small"
                >
                  {{ m }}
                </span>
            </td>
            <td>
              {{ ex.amount }} {{ ex.currency || 'THB' }}
              <span class="helper">
                  (base: {{ (ex.amountBase ?? ex.amount).toFixed(2) }})
                </span>
            </td>
            <td>
              <a
                  v-if="ex.receiptUrl"
                  :href="ex.receiptUrl"
                  target="_blank"
                  class="link"
              >
                View receipt
              </a>
              <span v-else class="helper">-</span>
              <div v-if="ex.voiceUrl" class="mt4">
                <audio :src="ex.voiceUrl" controls style="width:160px" />
              </div>
            </td>
            <td>
              <button class="btn-text" @click="openAddExpense(ex)">Edit</button>
              <button class="btn-text danger" @click="deleteExpenseRow(ex)">Delete</button>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

      <!-- Summary tab = Smart Settlement & PromptPay -->
      <div v-if="activeTab === 'summary'" class="mt16">
        <div class="grid-2">
          <div class="card p24">
            <div class="h2">Per member</div>
            <div class="mt8 helper">
              Base currency: {{ bill.baseCurrency || 'THB' }} | Rates: {{
                JSON.stringify(rates)
              }}
            </div>
            <table class="mt12 simple-table">
              <thead>
              <tr>
                <th>Member</th>
                <th>Paid</th>
                <th>Should pay</th>
                <th>Net</th>
              </tr>
              </thead>
              <tbody>
              <tr v-for="pm in summary?.perMember" :key="pm.name">
                <td>{{ pm.name }}</td>
                <td>{{ pm.paidFirst.toFixed(2) }}</td>
                <td>{{ pm.mustPay.toFixed(2) }}</td>
                <td :class="memberBalanceClass(pm.getMore)">
                  {{ pm.getMore.toFixed(2) }}
                </td>
              </tr>
              </tbody>
            </table>
            <div class="mt12">
              <b>Total base:</b> {{ totalBase.toFixed(2) }}
            </div>
          </div>

          <div class="card p24">
            <div class="h2">Smart settlement & PromptPay</div>
            <div class="helper mt4">
              ระบบคำนวณให้ว่าใครต้องจ่ายให้ใครเท่าไหร่ แล้วสามารถสร้าง PromptPay QR และบันทึกการจ่ายพร้อมแนบ
              payslip ได้
            </div>

            <div v-if="!summary?.transfers?.length" class="mt8 helper">
              Everyone is settled. No transfers needed.
            </div>
            <ul v-else class="mt8">
              <li
                  v-for="t in summary.transfers"
                  :key="t.from + '-' + t.to"
                  class="mt4"
              >
                <b>{{ t.from }}</b> pays
                <b>{{ t.to }}</b>
                <span> {{ t.amount.toFixed(2) }} THB</span>

                <button class="btn-text ml8" @click="openQr(t)">
                  PromptPay QR
                </button>
                <button class="btn-text ml8" @click="openPaymentModal(t)">
                  Mark paid + payslip
                </button>
              </li>
            </ul>

            <!-- PromptPay QR card -->
            <div v-if="qrTransfer" class="card mt16 p16 promptpay-card">
              <div class="h3">PromptPay QR</div>
              <div class="helper mt4">
                {{ qrTransfer.from }} pays {{ qrTransfer.to }}
                {{ qrTransfer.amount.toFixed(2) }} THB
              </div>
              <div class="mt8">
                <img
                    v-if="promptpayQrUrl"
                    :src="promptpayQrUrl"
                    alt="PromptPay QR"
                    class="qr-img"
                />
              </div>
              <div class="helper mt4">
                Using PromptPay number {{ PROMPTPAY_NUMBER }} (demo).
              </div>
              <button class="btn-outline mt8" @click="closeQr">Close QR</button>
            </div>

            <div class="mt16">
              <div class="h3">Payments history</div>
              <div v-if="!payments.length" class="mt4 helper">
                No payments recorded yet.
              </div>
              <ul v-else class="mt4">
                <li v-for="p in payments" :key="p.id">
                  {{ new Date(p.createdAt).toLocaleString() }}:
                  {{ p.from }} → {{ p.to }} {{ p.amount.toFixed(2) }}
                  <span v-if="p.method" class="helper">
                    ({{ p.method }})
                  </span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <!-- History tab = Group History with filters -->
      <div v-if="activeTab === 'history'" class="mt16 card p24">
        <div class="h2">Group history</div>
        <div class="helper mt4">
          ดูประวัติการใช้จ่ายของกลุ่มนี้ (เหมาะกับ recurring group / ทริปที่ผ่านมา) และกรองตาม
          <b>ช่วงเวลา</b> หรือ <b>สมาชิก</b> ได้
        </div>

        <div class="filters mt12">
          <div class="filter-item">
            <label class="label">From date</label>
            <input
                v-model="historyFrom"
                type="date"
                class="input"
            />
          </div>
          <div class="filter-item">
            <label class="label">To date</label>
            <input
                v-model="historyTo"
                type="date"
                class="input"
            />
          </div>
          <div class="filter-item">
            <label class="label">Member</label>
            <select v-model="historyMember" class="input">
              <option value="all">All members</option>
              <option
                  v-for="m in bill.members"
                  :key="m"
                  :value="m"
              >
                {{ m }}
              </option>
            </select>
          </div>
        </div>

        <ul class="mt16">
          <li v-if="!filteredHistoryPayments.length" class="helper">
            No history for this filter.
          </li>
          <li
              v-for="p in filteredHistoryPayments"
              :key="p.id"
              class="mt4"
          >
            {{ new Date(p.createdAt).toLocaleString() }}:
            {{ p.from }} → {{ p.to }} {{ p.amount.toFixed(2) }}
            <span v-if="p.method" class="helper">
              ({{ p.method }})
            </span>
          </li>
        </ul>
      </div>
    </div>

    <!-- Modal Add / Edit expense -->
    <ModalAddExpense
        v-if="bill"
        v-model:open="showAddExpense"
        :bill-id="bill.id"
        :members="bill.members"
        :expense="editingExpense"
        @saved="onExpenseSaved"
    />

    <!-- Modal Record payment + payslip -->
    <div v-if="showPaymentModal" class="modal-backdrop">
      <div class="modal">
        <div class="modal-header">
          <div class="title">Record payment</div>
          <button class="close" @click="showPaymentModal = false">×</button>
        </div>
        <div class="modal-body">
          <div v-if="paymentTarget" class="helper">
            {{ paymentTarget.from }} pays {{ paymentTarget.to }}
            {{ paymentTarget.amount.toFixed(2) }} THB
          </div>

          <div class="field mt12">
            <label class="label">Method</label>
            <select v-model="paymentMethod" class="input">
              <option value="PROMPTPAY">PromptPay</option>
              <option value="BANK">Bank transfer</option>
              <option value="CASH">Cash</option>
            </select>
          </div>

          <div class="field mt12">
            <label class="label">Reference / note</label>
            <input
                v-model="paymentRef"
                class="input"
                placeholder="Ref no. or note"
            />
          </div>

          <div class="field mt12">
            <label class="label">Payslip</label>
            <input
                type="file"
                accept="image/*,application/pdf"
                @change="onPayslipChange"
            />
            <div v-if="paymentPayslipPreview" class="mt8">
              <a
                  :href="paymentPayslipPreview"
                  target="_blank"
                  class="link"
              >
                Preview payslip
              </a>
              <button class="btn-text ml8" @click="removePayslip">
                Remove
              </button>
            </div>
            <div class="helper mt4">
              Demo mode: payslip is stored as a local preview URL and sent as
              payslipUrl to backend.
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-outline" @click="showPaymentModal = false">
            Cancel
          </button>
          <button class="btn" :disabled="!paymentTarget" @click="savePayment">
            Save
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.flex {
  display: flex;
}
.flex-between {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.gap8 {
  gap: 8px;
}
.wrap {
  flex-wrap: wrap;
}
.mt16 {
  margin-top: 16px;
}
.mt12 {
  margin-top: 12px;
}
.mt8 {
  margin-top: 8px;
}
.mt4 {
  margin-top: 4px;
}
.mb4 {
  margin-bottom: 4px;
}
.chip {
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  font-size: 12px;
}
.chip.small {
  font-size: 11px;
  padding: 2px 8px;
}
.tabs {
  display: flex;
  gap: 8px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.12);
}
.tab {
  padding: 8px 12px;
  border: none;
  background: none;
  color: #aaa;
  cursor: pointer;
  border-bottom: 2px solid transparent;
}
.tab.active {
  color: #fff;
  border-color: #35c9ff;
}
.expenses-table,
.simple-table {
  width: 100%;
  border-collapse: collapse;
}
.expenses-table th,
.expenses-table td,
.simple-table th,
.simple-table td {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 6px 8px;
  font-size: 13px;
}
.helper {
  font-size: 12px;
  color: #aaa;
}
.link {
  color: #35c9ff;
  text-decoration: underline;
  font-size: 13px;
}
.positive {
  color: #4caf50;
}
.negative {
  color: #f44336;
}
.grid-2 {
  display: grid;
  gap: 16px;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
}
.btn-danger-outline {
  background: transparent;
  border-radius: 999px;
  padding: 6px 14px;
  border: 1px solid #ff6b81;
  color: #ff6b81;
  cursor: pointer;
}
.btn-text {
  background: none;
  border: none;
  color: #35c9ff;
  cursor: pointer;
  font-size: 13px;
}
.btn-text.danger {
  color: #ff6b81;
}
.ml8 {
  margin-left: 8px;
}

/* PromptPay QR card */
.promptpay-card {
  background: rgba(0, 0, 0, 0.1);
  border-radius: 16px;
}
.qr-img {
  width: 160px;
  height: 160px;
  object-fit: contain;
}

/* Modal for record payment */
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2200;
}
.modal {
  background: #fff;
  border-radius: 18px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
  max-width: 520px;
  width: 100%;
  padding: 18px 20px 16px;
}
.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.title {
  font-size: 18px;
  font-weight: 600;
}
.close {
  border: none;
  background: none;
  font-size: 20px;
  cursor: pointer;
}
.modal-body {
  margin-top: 8px;
  max-height: 360px;
  overflow-y: auto;
}
.field {
  margin-top: 8px;
}
.input {
  width: 100%;
  padding: 8px 10px;
  border-radius: 8px;
  border: 1px solid #d9cfc7;
}
.label {
  font-size: 13px;
  font-weight: 500;
  margin-bottom: 4px;
  display: block;
}
.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 14px;
}
.btn-outline {
  border-radius: 999px;
  border: 1px solid #d9cfc7;
  background: #fff;
  padding: 6px 12px;
  cursor: pointer;
  font-size: 13px;
}
.btn {
  border: none;
  background: #35c9ff;
  color: #fff;
  padding: 8px 14px;
  border-radius: 999px;
  cursor: pointer;
  font-size: 13px;
}
.btn:disabled {
  opacity: 0.5;
  cursor: default;
}

/* History filters */
.filters {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.filter-item {
  min-width: 180px;
}
</style>
