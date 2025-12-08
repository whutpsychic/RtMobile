<template>
  <main class="app-body">
    首页
  </main>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
// -------------------------------- 控制键 --------------------------------
// -------------------------------- 数  据 --------------------------------
// -------------------------------- 方  法 --------------------------------
onMounted(() => {
  router.push('/developer')
})

</script>

<style scoped>
.app-body {
  display: flex;
  flex-direction: column;
  height: 100vh;
}

.content-area {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
}
</style>