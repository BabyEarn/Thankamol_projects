import { reactive, computed } from 'vue'
import axios from 'axios'

const api = axios.create({
    baseURL: import.meta.env.VITE_API_BASE || '/api',
})

function loadUser() {
    try {
        const raw = localStorage.getItem('user')
        if (!raw) return null
        return JSON.parse(raw)
    } catch {
        return null
    }
}

const state = reactive({
    user: loadUser(),
    token: localStorage.getItem('token') || null,
})

function saveSession(user, token) {
    state.user = user
    state.token = token
    localStorage.setItem('user', JSON.stringify(user))
    localStorage.setItem('token', token)
}

export function useAuth() {
    const isLoggedIn = computed(() => !!state.user)

    async function login({ username, password }) {
        try {
            const { data } = await api.post('/auth/login', { username, password })
            const user = data.user || { username }
            const token = data.token || 'demo-token'
            saveSession(user, token)
            return { ok: true }
        } catch (e) {
            // fallback demo user
            const user = { username, demo: true }
            saveSession(user, 'demo-token')
            return { ok: true, demo: true }
        }
    }

    async function register({ username, email, password }) {
        try {
            await api.post('/auth/register', { username, email, password })
            return { ok: true }
        } catch (e) {
            return { ok: false, error: e?.response?.data?.error || 'register failed' }
        }
    }

    function logout() {
        state.user = null
        state.token = null
        localStorage.removeItem('user')
        localStorage.removeItem('token')
        localStorage.removeItem('token_exp')
    }

    async function requestPasswordReset(email) {
        if (!email) {
            throw new Error('Email is required')
        }
        try {
            await api.post('/auth/forgot', { email })
            return { ok: true }
        } catch (e) {
            console.warn('requestPasswordReset fallback', e?.message || e)
            return { ok: true, demo: true }
        }
    }

    return {
        user: computed(() => state.user),
        token: computed(() => state.token),
        requestPasswordReset,
        isLoggedIn,
        login,
        register,
        logout,
    }
}
