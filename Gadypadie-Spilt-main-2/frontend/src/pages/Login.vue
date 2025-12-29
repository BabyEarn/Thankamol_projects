<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuth } from '../store/auth'

const router = useRouter()
const route = useRoute()
const { login } = useAuth()

const username = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')

async function onSubmit() {
  if (!username.value || !password.value) {
    error.value = 'Please fill in username and password'
    return
  }
  loading.value = true
  error.value = ''
  try {
    const res = await login({ username: username.value, password: password.value })
    if (res.ok) {
      const redirect = route.query.redirect || '/home'
      router.push(String(redirect))
    } else {
      error.value = res.error || 'Login failed'
    }
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="page-center">
    <div class="card auth-card">
      <h1 class="h1">Login</h1>
      <form class="mt16" @submit.prevent="onSubmit">
        <div class="field">
          <label>Username</label>
          <input v-model="username" class="input" autocomplete="username" />
        </div>
        <div class="field mt8">
          <label>Password</label>
          <input
            v-model="password"
            type="password"
            class="input"
            autocomplete="current-password"
          />
        </div>
        <div v-if="error" class="error mt8">{{ error }}</div>
        <button class="btn mt16" type="submit" :disabled="loading">
          {{ loading ? 'Logging in...' : 'Login' }}
        </button>
      </form>
      <div class="mt12 helper">
        No account?
        <router-link to="/register">Register</router-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-center {
  min-height: calc(100vh - 80px);
  display: flex;
  align-items: center;
  justify-content: center;
}
.auth-card {
  max-width: 360px;
  width: 100%;
}
.field label {
  font-size: 12px;
  color: #aaa;
  display: block;
  margin-bottom: 4px;
}
.error {
  color: #ff6b81;
  font-size: 13px;
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
.helper {
  font-size: 12px;
  color: #aaa;
}
</style>
