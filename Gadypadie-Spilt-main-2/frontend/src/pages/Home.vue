<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { fetchBills, createBill, deleteBill } from '../store/useBills'
import { useI18n } from 'vue-i18n'
import { useAuth } from '../store/auth'

const { t } = useI18n()
const auth = useAuth()
const router = useRouter()

const bills = ref([])
const newBillTitle = ref('')

async function load() {
  bills.value = await fetchBills()
}

async function createNewBill() {
  if (!newBillTitle.value.trim()) {
    newBillTitle.value = 'Untitled bill'
  }
  const bill = await createBill(newBillTitle.value)
  newBillTitle.value = ''
  if (bill && bill.id != null) {
    router.push(`/bill/${bill.id}`)
  } else {
    // fallback กันเหนียว
    await load()
  }
}

async function removeBill(id) {
  const ok = confirm('Delete this bill?')
  if (!ok) return
  await deleteBill(id)
  await load()
}

onMounted(load)
</script>

<template>
  <div class="p24">
    <div class="flex-between">
      <div>
        <h1 class="h1">GADYPADIE SPLIT</h1>
        <div class="helper">Smart group expense splitter for trips, meals, and more.</div>
      </div>
      <div v-if="auth.isLoggedIn" class="helper">
        {{ auth.user?.username }}
      </div>
    </div>

    <div class="card p24 mt16">
      <div class="h2">Create new bill</div>
      <div class="mt12 flex gap8">
        <input
            v-model="newBillTitle"
            class="input"
            placeholder="Trip to Chiang Mai"
            style="max-width: 320px"
        />
        <button class="btn" @click="createNewBill">
          Create
        </button>
      </div>
    </div>

    <div class="mt16">
      <div class="h2">Your bills</div>
      <div v-if="!bills.length" class="helper mt8">
        No bills yet. Create the first one above.
      </div>
      <div class="bill-grid mt12">
        <div
            v-for="b in bills"
            :key="b.id"
            class="card bill-card"
        >
          <div class="h3">
            {{ b.title || 'Untitled bill' }}
          </div>
          <div class="helper mt4">
            ID: {{ b.id }}
          </div>
          <div class="mt12 flex-between">
            <button class="btn-outline" @click="router.push(`/bill/${b.id}`)">
              Open
            </button>
            <button class="btn-danger-outline" @click="removeBill(b.id)">
              Delete
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.mt4 {
  margin-top: 4px;
}
.mt8 {
  margin-top: 8px;
}
.mt12 {
  margin-top: 12px;
}
.mt16 {
  margin-top: 16px;
}
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
.bill-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 16px;
}
.bill-card {
  min-height: 120px;
}
.helper {
  font-size: 12px;
  color: #aaa;
}
.btn-danger-outline {
  background: transparent;
  border-radius: 999px;
  padding: 6px 14px;
  border: 1px solid #ff6b81;
  color: #ff6b81;
  cursor: pointer;
}
</style>
