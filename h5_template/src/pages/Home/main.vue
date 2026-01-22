<template>
  <div class="app-can">
    App 首页
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import config from '@/appConfig'

const { developing } = config
const router = useRouter()


</script>

<style scoped>
.app-can {
  width: 100vw;
  height: calc(var(--vh, 1vh) * 100);
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
