import { ref } from 'vue'
import { defineStore } from 'pinia'

export const useSafeHeightsStore = defineStore('safeHeights', () => {
  const top = ref(0)
  const bottom = ref(0)

  function setup(vArr: number[]) {
    if (vArr && vArr.length > 0) {
      top.value = vArr[0]
      bottom.value = vArr[1]
    }
  }

  return { top, bottom, setup }
})
