<template>
  <RouterView />
</template>

<script setup lang="ts">
import { RouterView } from 'vue-router'
import { getSafeHeights } from '@/rtlink-mbridge'
import { useSafeHeightsStore } from '@/stores/safeHeights'

const sh = useSafeHeightsStore()

getSafeHeights().then((res: number[]) => {
  sh.setup(res)
})

</script>