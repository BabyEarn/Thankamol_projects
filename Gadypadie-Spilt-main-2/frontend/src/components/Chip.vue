<template>
  <span class="badge" :style="selected? 'outline:2px solid #a6978a;background:#fff':''" @click="$emit('toggle')"><slot/></span>
</template>
<script setup>
defineProps({ selected:Boolean })
</script>
