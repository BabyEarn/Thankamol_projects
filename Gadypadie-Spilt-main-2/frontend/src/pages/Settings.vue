<script setup>
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { setRatesFromCsv, getRates } from '../store/useBills'

const { locale, t } = useI18n()
const csvText = ref('USD,35\nEUR,38')
const currentRates = ref(getRates())

function switchLang(lang) {
  locale.value = lang
  localStorage.setItem('lang', lang)
}

function applyRates() {
  currentRates.value = setRatesFromCsv(csvText.value)
}
</script>

<template>
  <div class="p24">
    <h1 class="h1">{{ t('settings') }}</h1>

    <div class="card p24 mt16">
      <div class="h2">{{ t('language') }}</div>
      <div class="mt12" style="display:flex;gap:12px">
        <button class="btn" @click="switchLang('en')">
          {{ t('english') }}
        </button>
        <button class="btn" @click="switchLang('th')">
          {{ t('thai') }}
        </button>
      </div>
    </div>

    <div class="card p24 mt16">
      <div class="h2">Currency rates (CSV)</div>
      <div class="helper">
        Format: <code>CODE,rate</code> per line. Base currency is THB = 1.
      </div>
      <textarea
        v-model="csvText"
        rows="4"
        class="input mt8"
        style="width:100%;font-family:monospace"
      ></textarea>
      <div class="mt8">
        <button class="btn" @click="applyRates">
          Apply rates
        </button>
      </div>
      <div class="mt8 helper">
        Current rates: {{ JSON.stringify(currentRates) }}
      </div>
    </div>
  </div>
</template>

<style scoped>
.mt16 {
  margin-top: 16px;
}
.mt12 {
  margin-top: 12px;
}
.mt8 {
  margin-top: 8px;
}
.helper {
  font-size: 12px;
  color: #aaa;
}
</style>
