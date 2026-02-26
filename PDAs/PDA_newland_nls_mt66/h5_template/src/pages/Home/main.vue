<template>
  <AppCan>
    <div class="page-content">
      App 首页
    </div>
  </AppCan>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import config from '@/appConfig'
import AppCan from '@/views/AppCan.vue'

const { developing } = config
const router = useRouter()


</script>

<style scoped>
.page-content {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: orange
}
</style>
