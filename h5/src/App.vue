<template>
  <header>
    <img alt="Vue logo" class="logo" src="@/assets/logo.svg" width="125" height="125" />
  </header>
  <div class="btns">
    <van-uploader v-model="files" />
    <!-- <van-button type="primary" block class="btn" @click="onTest">test</van-button> -->
    <van-button type="primary" block class="btn" @click="onGetDeviceInfo">获取设备信息</van-button>
    <van-button type="primary" block class="btn" @click="onWriteLocal">写入本地缓存</van-button>
    <van-button type="primary" block class="btn" @click="onReadLocal">读取本地缓存</van-button>
    <van-button type="primary" block class="btn" @click="onPreDial">拨打电话: 13888888888</van-button>
    <van-button type="primary" block class="btn" @click="onCheckoutNetwork">检查网络连接状态</van-button>
    <van-button type="primary" block class="btn" @click="onSetScreenHorizontal">切为横屏</van-button>
    <van-button type="primary" block class="btn" @click="onSetScreenPortrait">切为竖屏</van-button>
    <van-button type="primary" block class="btn" @click="onScan">扫描二维码</van-button>
    <p class="text">扫码结果: {{ result }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref, type Ref } from 'vue'
import rtm from '$'
// import { isIOS, isAndroid } from '$'
import {
  scan,
  getDeviceInfo,
  writeLocal,
  readLocal,
  preDial,
  checkoutNetwork,
  setScreenHorizontal,
  setScreenPortrait,
} from '$'
import { showToast } from 'vant'

const result: Ref<string> = ref('')

rtm.init()

const files = ref([])

// const onTest = () => {
  
// }

// 写入本地缓存
const onWriteLocal = async () => {
  await writeLocal('key1', 'value111111', 5)
  showToast('写入成功')
}

// 读取本地缓存
const onReadLocal = async () => {
  const res: string = await readLocal('key1')
  showToast(`读取键名为key1的缓存值为${res}`)
}

// 电话拨号
const onPreDial = () => {
  preDial('13888888888')
}

// 检查网络连接状态
const onCheckoutNetwork = async () => {
  const res: string = await checkoutNetwork()
  showToast(`网络连接类型为 ${res}`)
}

// 横屏
const onSetScreenHorizontal = async () => {
  await setScreenHorizontal()
  showToast(`已将屏幕锁定为横向`)
}

// 竖屏
const onSetScreenPortrait = async () => {
  await setScreenPortrait()
  showToast(`已将屏幕锁定为竖向`)
}

// 获取设备信息
const onGetDeviceInfo = async () => {
  const res: string = await getDeviceInfo()
  try {
    const data = JSON.parse(res)
    const { systemName, systemVersion, deviceName, modelDisplayName, screenWidth, screenHeight, orientation, deviceId } = data
    const result = `系统名称: ${systemName}\n 系统版本: ${systemVersion}\n 设备名称: ${deviceName}\n 型号名称: ${modelDisplayName}\n 屏幕尺寸: ${screenWidth} x ${screenHeight}\n 当前方向: ${orientation}\n 设备唯一标识符: ${deviceId} \n自 Android10 起，已无法再获取唯一标识`
    showToast({
      duration: 0,
      closeOnClick: true,
      message: result
    })
  } catch (err) {
    console.error(err)
  }
}

// 混合扫码
const onScan = async () => {
  const res = await scan()
  if (res) {
    showToast(`扫码结果为${res}`)
    result.value = `${res}`
  }
}
</script>

<style scoped>
header {
  width: 100%;
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.btns {
  display: block;
  width: 100%;
}

p.text {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 0.5em;
}

.btn {
  margin-bottom: 1em;
}
</style>
