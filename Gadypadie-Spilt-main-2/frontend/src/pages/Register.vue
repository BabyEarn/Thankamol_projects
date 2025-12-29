<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '../store/auth'

const router = useRouter()
const { register } = useAuth()

const username = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const loading = ref(false)
const error = ref('')
const success = ref('')

async function onSubmit() {
  error.value = ''
  success.value = ''

  if (!username.value || !email.value || !password.value || !confirmPassword.value) {
    error.value = 'Please fill in all fields'
    return
  }
  if (password.value !== confirmPassword.value) {
    error.value = 'Password does not match'
    return
  }

  loading.value = true
  try {
    const res = await register({
      username: username.value,
      email: email.value,
      password: password.value,
    })
    if (!res.ok) {
      error.value = res.error || 'Register failed'
      return
    }
    success.value = 'Register success. You can login now.'
    setTimeout(() => {
      router.push('/login')
    }, 1000)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="page-center">
    <div class="card auth-card">
      <h1 class="h1">Register</h1>
      <form class="mt16" @submit.prevent="onSubmit">
        <div class="field">
          <label>Username</label>
          <input v-model="username" class="input" autocomplete="username" />
        </div>
        <div class="field mt8">
          <label>Email</label>
          <input v-model="email" class="input" autocomplete="email" />
        </div>
        <div class="field mt8">
          <label>Password</label>
          <input
            v-model="password"
            type="password"
            class="input"
            autocomplete="new-password"
          />
        </div>
        <div class="field mt8">
          <label>Confirm password</label>
          <input
            v-model="confirmPassword"
            type="password"
            class="input"
            autocomplete="new-password"
          />
        </div>
        <div v-if="error" class="error mt8">{{ error }}</div>
        <div v-if="success" class="success mt8">{{ success }}</div>
        <button class="btn mt16" type="submit" :disabled="loading">
          {{ loading ? 'Registering...' : 'Register' }}
        </button>
      </form>
      <div class="mt12 helper">
        Already have account?
        <router-link to="/login">Login</router-link>
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
  max-width: 380px;
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
.success {
  color: #4caf50;
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
