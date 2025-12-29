<script setup>
import { onMounted, ref } from 'vue'
import { useAuth } from '../store/auth'
const auth = useAuth()
const CLIENT_ID = import.meta.env.VITE_GOOGLE_CLIENT_ID
const ready = ref(false)
const containerId = 'google-btn-container'

function loadGis(){
  return new Promise((resolve,reject)=>{
    if (window.google && window.google.accounts && window.google.accounts.id){ resolve(); return }
    const s = document.createElement('script')
    s.src = 'https://accounts.google.com/gsi/client'
    s.async = true; s.defer = true
    s.onload = () => resolve()
    s.onerror = () => reject(new Error('Failed to load Google Identity Services'))
    document.head.appendChild(s)
  })
}

onMounted(async() => {
  if(!CLIENT_ID) return
  try{
    await loadGis()
    window.google.accounts.id.initialize({
      client_id: CLIENT_ID,
      callback: async (resp) => {
        if(!resp || !resp.credential) return
        const ok = await auth.oauthLogin({ provider:'google', idToken: resp.credential })
        if(ok){
          const next = new URLSearchParams(location.hash.split('?')[1]||'').get('next') || '/home'
          window.location.hash = '#' + next
        }
      }
    })
    const el = document.getElementById(containerId)
    if (el){
      window.google.accounts.id.renderButton(el, {
        theme: 'outline',
        size: 'large',
        type: 'standard',
        text: 'continue_with',
        shape: 'pill'
      })
    }
    ready.value = true
  }catch(e){
    console.error(e)
  }
})
</script>

<template>
  <div v-if="CLIENT_ID" :id="containerId"></div>
  <button v-else class="btn-outline" disabled title="Set VITE_GOOGLE_CLIENT_ID to enable Google login">
    Continue with Google
  </button>
</template>
