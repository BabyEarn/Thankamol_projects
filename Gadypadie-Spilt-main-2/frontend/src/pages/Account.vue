<script setup>
import { useAuth } from '../store/auth'
import { useI18n } from 'vue-i18n'
import { ref } from 'vue'
const auth = useAuth()
const { locale } = useI18n()
const name = ref(auth?.state?.user?.username || '')
const email = ref(auth?.state?.user?.email || '')
function setLang(l){ locale.value=l; localStorage.setItem('lang', l) }
</script>

<template>
  <div v-if="!auth.state.user" class="p24">
    <div class="card p24 center" style="max-width:560px;margin:0 auto">
      <div class="h2">Please login</div>
      <div class="mt12"><router-link :to="{ path:'/login', query:{ next:'/account' } }" class="btn">Go to Login</router-link></div>
    </div>
  </div>
  <div v-else>
  <div class="p24">
    <div class="h1 mb16">Account</div>
    <div class="card p24" style="max-width:720px;margin:0 auto">
      <div class="grid" style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
        <label><div class="helper">Username</div><input class="input" v-model="name" disabled /></label>
        <label><div class="helper">Email</div><input class="input" v-model="email" disabled /></label>
      </div>

      <div class="mt16">
        <div class="helper">Language</div>
        <div style="display:flex;gap:10px;margin-top:8px">
          <button class="btn-outline" :class="{active: locale==='en'}" @click="setLang('en')">EN</button>
          <button class="btn-outline" :class="{active: locale==='th'}" @click="setLang('th')">TH</button>
        </div>
      </div>
      <div class="grid mt16" style="display:grid;grid-template-columns:1fr 1fr;gap:16px"><label><div class="helper">Provider</div><input class="input" :value="auth?.state?.user?.provider || 'local'" disabled /></label><label><div class="helper">User ID</div><input class="input" :value="auth?.state?.user?.id || '-'" disabled /></label></div>

      <div class="mt24" style="display:flex;gap:12px">
        <button class="btn" @click="$router.push('/home')">Back to Home</button>
        <div style="flex:1"></div>
        <button class="btn-outline" @click="$router.push('/login'); auth.signOut()">Sign out</button>
      </div>
    </div>
  </div>
</div>
</template>

<style scoped>
.btn-outline.active{ background:#333; color:#fff; border-color:#333; }
</style>
