<template>
  <aside class="sidebar">
    <div class="sb-top">
      <router-link to="/home" class="sidebtn" title="Home">
        <span class="sb-ic">🏠</span>
      </router-link>
      <router-link to="/account" class="sidebtn" title="Account">
        <span class="sb-ic">👤</span>
      </router-link>
      <router-link to="/settings" class="sidebtn" title="Settings">
        <span class="sb-ic">⚙️</span>
      </router-link>
    </div>
    <div class="sb-bottom">
      <!-- future items -->
    </div>
  </aside>
</template>

<script setup>
// no script needed for now
</script>

<style scoped>
.sidebar {
  width: 56px;
  min-width: 56px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 12px 8px;
  border-right: 1px solid #d9cfc7;
  background: #fff;
  position: relative;
}

.sb-top {
  display: flex;
  flex-direction: column;
  gap: 8px;
  width: 100%;
  align-items: center;
}

.sb-bottom {
  position: absolute;
  bottom: 12px;
  left: 0;
  right: 0;
  display: flex;
  justify-content: center;
}

.sidebtn {
  width: 40px;
  height: 40px;
  border-radius: 999px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid transparent;
  text-decoration: none;
  color: #333;
  background: #fff;
  transition: background 0.15s ease, border-color 0.15s ease;
}

.sidebtn.router-link-active {
  border-color: #35c9ff;
  background: #e8f7ff;
}

.sb-ic {
  font-size: 18px;
}
</style>
