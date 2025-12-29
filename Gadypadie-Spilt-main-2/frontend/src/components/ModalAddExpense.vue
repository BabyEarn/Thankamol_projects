<script setup>
import { ref, computed, watch } from 'vue'
import {
  addExpense,
  updateExpense,
  getRates,
  getDemoGroups,
  addGroupMembers,
} from '../store/useBills'

const props = defineProps({
  billId: {
    type: [String, Number],
    required: true,
  },
  open: {
    type: Boolean,
    default: false,
  },
  members: {
    type: Array,
    default: () => [],
  },
  // ถ้ามีค่า = โหมด Edit
  expense: {
    type: Object,
    default: null,
  },
})

const emit = defineEmits(['update:open', 'saved'])

const description = ref('')
const tag = ref('')
const payer = ref('')
const selectedMembers = ref([])
const amount = ref(0)
const currency = ref('THB')
const splitMode = ref('EQUAL') // EQUAL | AMOUNT | PERCENT | TAG

const receiptFile = ref(null)
const voiceFile = ref(null)
const receiptPreview = ref(null)
const voicePreview = ref(null)

// กันกรณี getDemoGroups / getRates คืนค่า undefined
const groups = ref(getDemoGroups() || [])
const selectedGroup = ref('')
const rates = ref(getRates() || {})

const customAmounts = ref({})
const customPercents = ref({})
const tagDrinkers = ref([])

const isEditMode = computed(() => !!(props.expense && props.expense.id))

const canSave = computed(() => {
  return description.value.trim() && amount.value > 0
})

// เติมค่าจาก expense ตอน Edit หรือ reset ตอน Add
function fillFromExpense(ex) {
  if (!ex) {
    description.value = ''
    tag.value = ''
    payer.value = ''
    selectedMembers.value = []
    amount.value = 0
    currency.value = 'THB'
    splitMode.value = 'EQUAL'
    customAmounts.value = {}
    customPercents.value = {}
    tagDrinkers.value = []
    receiptFile.value = null
    voiceFile.value = null
    receiptPreview.value = null
    voicePreview.value = null
    return
  }

  description.value = ex.description || ''
  tag.value = ex.tag || ''
  payer.value = ex.payer || ''
  selectedMembers.value = ex.participants ? [...ex.participants] : []
  amount.value = Number(ex.amount || 0)
  currency.value = ex.currency || 'THB'
  splitMode.value = ex.splitMode || 'EQUAL'
  customAmounts.value = ex.customAmounts || {}
  customPercents.value = ex.customPercents || {}
  tagDrinkers.value = ex.tagDrinkers ? [...ex.tagDrinkers] : []
  receiptPreview.value = ex.receiptUrl || null
  voicePreview.value = ex.voiceUrl || null
}

// watch เวลา expense เปลี่ยน (กด Edit)
watch(
    () => props.expense,
    (val) => {
      fillFromExpense(val)
    },
    { immediate: true },
)

// watch เวลาเปิด / ปิด modal
watch(
    () => props.open,
    (val) => {
      if (val && !props.expense) {
        // เปิดโหมด Add → reset
        fillFromExpense(null)
      }
    },
)

function close() {
  emit('update:open', false)
}

function toggleMember(name) {
  const idx = selectedMembers.value.indexOf(name)
  if (idx === -1) selectedMembers.value.push(name)
  else selectedMembers.value.splice(idx, 1)
}

function isMemberSelected(name) {
  return selectedMembers.value.includes(name)
}

function selectAllMembers() {
  selectedMembers.value = [...props.members]
}

function clearMembers() {
  selectedMembers.value = []
  tagDrinkers.value = []
  customAmounts.value = {}
  customPercents.value = {}
}

async function addSelectedGroup() {
  if (!selectedGroup.value) return

  // เรียก backend / demo store
  await addGroupMembers(props.billId, selectedGroup.value)

  // merge รายชื่อเข้า participants
  const group = groups.value.find((g) => g.name === selectedGroup.value)
  if (group && Array.isArray(group.members)) {
    const set = new Set(selectedMembers.value)
    group.members.forEach((m) => set.add(m))
    selectedMembers.value = Array.from(set)
  }
  selectedGroup.value = ''
}

function onReceiptChange(e) {
  const file = e.target.files && e.target.files[0]
  receiptFile.value = file || null
  receiptPreview.value = file ? URL.createObjectURL(file) : null
}

function onVoiceChange(e) {
  const file = e.target.files && e.target.files[0]
  voiceFile.value = file || null
  voicePreview.value = file ? URL.createObjectURL(file) : null
}

function removeReceipt() {
  receiptFile.value = null
  receiptPreview.value = null
}

function removeVoice() {
  voiceFile.value = null
  voicePreview.value = null
}

function toggleDrinker(name) {
  const idx = tagDrinkers.value.indexOf(name)
  if (idx === -1) tagDrinkers.value.push(name)
  else tagDrinkers.value.splice(idx, 1)
}

async function save() {
  if (!canSave.value) return

  let receiptUrl = props.expense && props.expense.receiptUrl ? props.expense.receiptUrl : null
  let voiceUrl = props.expense && props.expense.voiceUrl ? props.expense.voiceUrl : null

  if (receiptFile.value) {
    receiptUrl = '(demo) local-receipt-' + receiptFile.value.name
  }
  if (voiceFile.value) {
    voiceUrl = '(demo) local-voice-' + voiceFile.value.name
  }

  const rate = rates.value[currency.value] || 1

  const payload = {
    description: description.value.trim(),
    payer: payer.value || null,
    participants: [...selectedMembers.value],
    amount: Number(amount.value),
    currency: currency.value,
    splitMode: splitMode.value,
    tag: tag.value || null,
    customAmounts: customAmounts.value,
    customPercents: customPercents.value,
    tagDrinkers: [...tagDrinkers.value],
    receiptUrl,
    voiceUrl,
  }

  payload.amountBase = Number((payload.amount * rate).toFixed(2))

  if (isEditMode.value) {
    await updateExpense(props.billId, props.expense.id, payload)
  } else {
    await addExpense(props.billId, payload)
  }

  emit('saved')
  emit('update:open', false)
}
</script>

<template>
  <div v-if="open" class="modal-backdrop">
    <div class="modal">
      <div class="modal-header">
        <div class="title">
          {{ isEditMode ? 'Edit expense' : 'Add expense' }}
        </div>
        <button class="close" @click="close">×</button>
      </div>

      <div class="modal-body">
        <!-- Description + Tag + Payer -->
        <div class="field">
          <label>Description</label>
          <input
              v-model="description"
              class="input"
              placeholder="e.g. Dinner at mall"
          />
        </div>

        <div class="field two-cols">
          <div>
            <label>Tag</label>
            <input
                v-model="tag"
                class="input"
                placeholder="e.g. Food, Transport, Alcohol"
            />
          </div>
          <div>
            <label>Payer</label>
            <select v-model="payer" class="input">
              <option value="">Select payer</option>
              <option v-for="m in members" :key="m" :value="m">
                {{ m }}
              </option>
            </select>
          </div>
        </div>

        <!-- Participants -->
        <div class="field">
          <label>Participants</label>
          <div class="chips">
            <button
                v-for="m in members"
                :key="m"
                type="button"
                class="chip"
                :class="{ selected: isMemberSelected(m) }"
                @click="toggleMember(m)"
            >
              {{ m }}
            </button>
          </div>
          <div class="mt4">
            <button type="button" class="btn-outline small" @click="selectAllMembers">
              Select all
            </button>
            <button type="button" class="btn-outline small ml8" @click="clearMembers">
              Clear
            </button>
          </div>

          <div class="mt8">
            <label class="label">Add participants by group</label>
            <div class="row">
              <select v-model="selectedGroup" class="input">
                <option value="">Select group</option>
                <option v-for="g in groups" :key="g.name" :value="g.name">
                  {{ g.name }}
                </option>
              </select>
              <button type="button" class="btn-outline ml8" @click="addSelectedGroup">
                Add group
              </button>
            </div>
          </div>
        </div>

        <!-- Amount + Currency -->
        <div class="field two-cols">
          <div>
            <label>Amount</label>
            <input
                v-model.number="amount"
                type="number"
                min="0"
                step="0.01"
                class="input"
            />
          </div>
          <div>
            <label>Currency</label>
            <select v-model="currency" class="input">
              <option value="THB">THB</option>
              <option value="USD">USD</option>
              <option value="EUR">EUR</option>
            </select>
          </div>
        </div>

        <!-- Split mode -->
        <div class="field">
          <label>Split mode</label>
          <select v-model="splitMode" class="input">
            <option value="EQUAL">Equal split (หารเท่ากัน)</option>
            <option value="AMOUNT">Manual split by amount</option>
            <option value="PERCENT">Manual split by percent</option>
            <option value="TAG">Tag-based split (เช่น Alcohol only)</option>
          </select>
        </div>

        <!-- Manual split by amount -->
        <div v-if="splitMode === 'AMOUNT'" class="field">
          <div class="label">Manual amount per participant</div>
          <table class="split-table">
            <thead>
            <tr>
              <th>Member</th>
              <th>Amount ({{ currency }})</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="m in selectedMembers" :key="m">
              <td>{{ m }}</td>
              <td>
                <input
                    v-model.number="customAmounts[m]"
                    type="number"
                    min="0"
                    step="0.01"
                    class="input"
                />
              </td>
            </tr>
            </tbody>
          </table>
          <div class="helper mt4">
            ใช้สำหรับเคสที่แต่ละคนจ่ายหรือกินไม่เท่ากัน (ตอนนี้ summary ยังคิดแบบ equal
            แต่เก็บข้อมูลไว้ใน expense สำหรับ future work / test case)
          </div>
        </div>

        <!-- Manual split by percent -->
        <div v-if="splitMode === 'PERCENT'" class="field">
          <div class="label">Manual percent per participant</div>
          <table class="split-table">
            <thead>
            <tr>
              <th>Member</th>
              <th>Percent (%)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="m in selectedMembers" :key="m">
              <td>{{ m }}</td>
              <td>
                <input
                    v-model.number="customPercents[m]"
                    type="number"
                    min="0"
                    step="0.01"
                    class="input"
                />
              </td>
            </tr>
            </tbody>
          </table>
          <div class="helper mt4">
            ใช้สำหรับกำหนดสัดส่วนเปอร์เซ็นต์ (รวมกันควรใกล้ 100%)
          </div>
        </div>

        <!-- Tag-based split -->
        <div v-if="splitMode === 'TAG'" class="field">
          <div class="label">Tag-based split</div>
          <div class="helper mt4">
            ตัวอย่าง: Tag = “Alcohol” แล้วติ๊กเฉพาะคนที่ดื่ม เพื่อใช้ใน test case Tag-based split
          </div>

          <div class="mt8">
            <label class="label">Tag</label>
            <input
                v-model="tag"
                class="input"
                placeholder="e.g. Alcohol"
            />
          </div>

          <div class="mt8">
            <div class="label">Members who are included in this tag</div>
            <div class="chips">
              <button
                  v-for="m in selectedMembers"
                  :key="m"
                  type="button"
                  class="chip"
                  :class="{ selected: tagDrinkers.includes(m) }"
                  @click="toggleDrinker(m)"
              >
                {{ m }}
              </button>
            </div>
          </div>
        </div>

        <!-- Attachments -->
        <div class="field">
          <label>Invoice / Receipt file</label>
          <input type="file" accept="image/*,application/pdf" @change="onReceiptChange" />
          <div class="helper mt4">
            อัปโหลดไฟล์ใบเสร็จ / invoice (รูปภาพ หรือ PDF)
          </div>
          <div v-if="receiptPreview" class="mt8">
            <a :href="receiptPreview" target="_blank" class="link">Preview invoice</a>
            <button type="button" class="btn-text ml8" @click="removeReceipt">Remove</button>
          </div>
        </div>

        <div class="field">
          <label>Voice file (เสียงอธิบาย)</label>
          <input type="file" accept="audio/*" @change="onVoiceChange" />
          <div class="helper mt4">
            อัปโหลดไฟล์เสียง (voice note) เช่น อธิบายรายละเอียดค่าใช้จ่าย
          </div>
          <div v-if="voicePreview" class="mt8">
            <audio :src="voicePreview" controls style="max-width: 100%"></audio>
            <button type="button" class="btn-text ml8" @click="removeVoice">Remove</button>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn-outline" @click="close">Cancel</button>
          <button class="btn" :disabled="!canSave" @click="save">
            {{ isEditMode ? 'Save changes' : 'Save expense' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}

.modal {
  background: #fff;
  border-radius: 18px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
  max-width: 720px;
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
  margin-top: 12px;
  max-height: 480px;
  overflow-y: auto;
}

.field {
  margin-top: 12px;
}

.field:first-of-type {
  margin-top: 0;
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

.helper {
  font-size: 11px;
  color: #777;
  margin-top: 4px;
}

.row {
  display: flex;
  align-items: center;
}

.two-cols {
  display: grid;
  grid-template-columns: 1.1fr 0.9fr;
  gap: 12px;
}

.chips {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 6px;
}

.chip {
  border-radius: 999px;
  border: 1px solid #d9cfc7;
  background: #f8f5f2;
  padding: 4px 10px;
  font-size: 12px;
  cursor: pointer;
}

.chip.selected {
  background: #35c9ff;
  border-color: #35c9ff;
  color: #fff;
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

.btn-outline {
  border-radius: 999px;
  border: 1px solid #d9cfc7;
  background: #fff;
  padding: 6px 12px;
  cursor: pointer;
  font-size: 13px;
}

.btn-text {
  background: none;
  border: none;
  color: #35c9ff;
  cursor: pointer;
  font-size: 12px;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 14px;
}

.link {
  font-size: 12px;
  color: #35c9ff;
  text-decoration: underline;
}

.split-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 6px;
  font-size: 12px;
}

.split-table th,
.split-table td {
  border-bottom: 1px solid #eee;
  padding: 4px 6px;
  text-align: left;
}

.ml8 {
  margin-left: 8px;
}

.mt4 {
  margin-top: 4px;
}

.mt8 {
  margin-top: 8px;
}

.small {
  padding: 4px 10px;
  font-size: 12px;
}
</style>
