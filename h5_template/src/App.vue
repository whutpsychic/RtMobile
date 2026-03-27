<template>
  <RouterView />
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import rtm from 'rtlink-mbridge'
import { getDeviceInfo, toastAndroid } from 'rtlink-mbridge'
import { useDeviceStore } from '@/stores/device-info'

const deviceStore = useDeviceStore()

rtm.init();

const init = async () => {
  const res: string = await getDeviceInfo()
  try {
    const data = JSON.parse(res)
    // const { systemName, systemVersion, deviceName, modelDisplayName, screenWidth, screenHeight, orientation, deviceId } = data
    // const result = `系统名称: ${systemName}\n 系统版本: ${systemVersion}\n 设备名称: ${deviceName}\n 型号名称: ${modelDisplayName}\n 屏幕尺寸: ${screenWidth} x ${screenHeight}\n 当前方向: ${orientation}\n 设备唯一标识符: ${deviceId} \n自 Android10 起，已无法再获取唯一标识`
    deviceStore.setData(data)
  } catch (err) {
    console.error(err)
  }
}

onMounted(() => {
  setTimeout(() => {
    init()
  }, 10)
})

</script>