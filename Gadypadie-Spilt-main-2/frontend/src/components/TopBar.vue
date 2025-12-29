<template>
  <header class="topbar">
    <div class="left">
      <img class="logo" :src="logo" alt="logo" @click="goHome" />
      <span class="title" @click="goHome">GADYPADIE SPLIT</span>
    </div>

    <div class="right">
      <!-- แสดงชื่อผู้ใช้ -->
      <span v-if="auth.user" class="username">
        {{ auth.user.username || "User" }}
      </span>
      <span v-else class="username">
        Guest
      </span>

      <!-- เปลี่ยนภาษา -->
      <button class="lang" @click="setLang('th')">TH</button>
      <button class="lang" @click="setLang('en')">EN</button>

      <!-- ปุ่ม Logout -->
      <button v-if="auth.user" class="logout" @click="logoutUser">Logout</button>
      <button v-else class="logout" @click="goLogin">Login</button>
    </div>
  </header>
</template>

<script setup>
import logo from '../assets/logo1.png'
import { useAuth } from '../store/auth'
import { useI18n } from 'vue-i18n'

const auth = useAuth()
const { locale } = useI18n()

function setLang(l) {
  locale.value = l
  localStorage.setItem('lang', l)
}

function goHome() {
  window.location.hash = '#/home'
}
function goLogin() {
  window.location.hash = '#/login'
}

function logoutUser() {
  auth.logout()
  window.location.hash = '#/login'
}
</script>

<style scoped>
.topbar {
  height: 52px;
  background: #fff;
  border-bottom: 1px solid #d9cfc7;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 14px;
  user-select: none;
}

.left {
  display: flex;
  align-items: center;
  gap: 6px;
}
.logo {
  width: 28px;
  height: 28px;
  cursor: pointer;
}
.title {
  font-weight: 600;
  cursor: pointer;
}

.right {
  display: flex;
  gap: 10px;
  align-items: center;
}

.username {
  font-weight: 500;
  color: #333;
}

.lang {
  border: none;
  background: #e8e8e8;
  padding: 3px 6px;
  border-radius: 4px;
  cursor: pointer;
}
.lang:hover {
  background: #dcdcdc;
}

.logout {
  border: 1px solid #ccc;
  padding: 4px 8px;
  border-radius: 4px;
  cursor: pointer;
  background: #fff;
}
.logout:hover {
  background: #ffeaea;
}
</style>
