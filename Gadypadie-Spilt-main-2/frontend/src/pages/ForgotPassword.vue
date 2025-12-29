<script setup>
import { ref } from 'vue'
import { useAuth } from '../store/auth'
const auth = useAuth()
const email = ref('')
const sent = ref(false)
const error = ref('')
async function submit(){
  error.value=''
  try{
    await auth.requestPasswordReset(email.value)
    sent.value=true
  }catch(e){
    error.value = (e?.message)||'Failed'
  }
}
</script>
<template>
  <div class="p24">
    <div class="h1 center mb16">Forgot password</div>
    <div class="card p24" style="max-width:600px;margin:0 auto">
      <template v-if="!sent">
        <div class="mt8"><input class="input" v-model="email" placeholder="Email" /></div>
        <div v-if="error" class="helper" style="color:#b00020">{{ error }}</div>
        <div class="mt16" style="display:flex;gap:12px;justify-content:center">
          <button class="btn" @click="submit">Send reset link</button>
          <button class="btn-outline" @click="$router.push('/login')">Back to login</button>
        </div>
      </template>
      <template v-else>
        <div class="center" style="padding:20px">Check your email for the reset link.</div>
        <div class="mt16 center"><button class="btn-outline" @click="$router.push('/login')">Back to login</button></div>
      </template>
    </div>
  </div>
</template>
