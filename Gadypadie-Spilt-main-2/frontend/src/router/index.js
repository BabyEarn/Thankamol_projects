import { createRouter, createWebHistory } from 'vue-router'
import Home from '../pages/Home.vue'
import Settings from '../pages/Settings.vue'
import Login from '../pages/Login.vue'
import Register from '../pages/Register.vue'
import Account from '../pages/Account.vue'
import BillDetail from '../pages/BillDetail.vue'
import Landing from '../pages/Landing.vue'
import ForgotPassword from '../pages/ForgotPassword.vue'
import { useAuth } from '../store/auth'

const routes = [
  { path: '/', redirect: '/landing' },
  { path: '/landing', component: Landing },

  // public
  { path: '/home', component: Home },
  { path: '/settings', component: Settings },
  { path: '/login', component: Login },
  { path: '/register', component: Register },
  { path: '/forgot', component: ForgotPassword },

  // protected
  { path: '/account', component: Account, meta: { requiresAuth: true } },
  { path: '/bill/:id', component: BillDetail, meta: { requiresAuth: true } },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

router.beforeEach((to, from, next) => {
  const publicPaths = ['/login', '/register', '/forgot', '/landing', '/home', '/settings']
  const isPublic = publicPaths.includes(to.path)
  const { isLoggedIn } = useAuth()

  if (!isPublic && to.meta.requiresAuth && !isLoggedIn.value) {
    next({ path: '/login', query: { redirect: to.fullPath } })
  } else {
    next()
  }
})

export default router
