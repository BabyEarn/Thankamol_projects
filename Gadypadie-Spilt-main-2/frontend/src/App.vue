<template>
  <div class="app-shell">
    <TopBar />
    <div class="shell">
      <SideBar />
      <main class="panel">
        <router-view />
      </main>
    </div>
  </div>
</template>
<script setup>
import TopBar from './components/TopBar.vue'
import SideBar from './components/SideBar.vue'
</script>
