<template>
  <van-nav-bar :style="`padding-top:${safeTop}px;`" :title="title" :left-text="withBackupBtn ? `返回` : undefined"
    :left-arrow="withBackupBtn ? true : false" @click-left="backup" />
  <slot></slot>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useSafeHeightsStore } from '@/stores/safeHeights'
import config from '@/appConfig'

const { developing } = config

const props = defineProps({
  title: { type: String, default: "" },
  noback: { type: Boolean, default: false },
})

const router = useRouter()

function backup() {
  router.back()
}

const sh = useSafeHeightsStore()

const safeTop = computed(() => sh.top)

const withBackupBtn = computed(() => {
  // 如果是调试模式，则就允许返回
  if (developing) {
    return true
  }
  // 受外部属性 noback 节制
  if (props.noback) {
    return false
  }
  else {
    return true
  }
})

</script>