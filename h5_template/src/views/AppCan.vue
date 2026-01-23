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
  height: calc(var(--vh, 1vh) * 100);
  padding-top: var(--safe-area-top);
  background-color: purple
}
</style>