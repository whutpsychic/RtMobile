<template>
  <div class="app-can">
    <slot></slot>
  </div>
</template>

<script setup lang="ts">

</script>

<style scoped>
.app-can {
  width: 100vw;
  height: 100vh;
  padding-top: var(--safe-area-top);
  background-color: purple
}
</style>