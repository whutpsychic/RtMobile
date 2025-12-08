<template>
  <rtm-app-container title="原生功能" canPop>
    <template #body>
      <div style="width: 100%;height:38px;background-color: purple;"></div>
      <img alt="Vue logo" class="logo" src="@/assets/logo.png" width="168" height="32" style="margin: 20px;" />
      <div style="width: 100%;height:30px;"></div>
      <van-uploader v-model="dm" multiple></van-uploader>
      <div style="width: 100%;height:30px;"></div>
      <van-button class="btn" type="primary" block @click="onGetDeviceInfo">获取设备信息</van-button>
      <van-button class="btn" type="primary" block @click="showToast('显示toast.')">Toast</van-button>
      <van-button class="btn" type="primary" block @click="onModalTips">ModalTips</van-button>
      <van-button class="btn" type="primary" block @click="onModalConfirm">ModalConfirm</van-button>
      <van-button class="btn" type="primary" block @click="onModalLoading">ModalLoading</van-button>
      <van-button class="btn" type="primary" block @click="onModalProgress">ModalProgress</van-button>
      <van-button class="btn" type="primary" block @click="writeLocal('damn', 'God damn it!')">WriteLocal</van-button>
      <van-button class="btn" type="primary" block @click="onReadLocal">ReadLocal</van-button>
      <van-button class="btn" type="primary" block @click="onScan">Scan Mix</van-button>
      <van-button class="btn" type="primary" block @click="preDial('18043730725')">Dial Number: 18043730725</van-button>
      <van-button class="btn" type="primary" block @click="onCheckNetworkType">NetWork Type</van-button>
      <van-button class="btn" type="primary" block @click="onTakePhoto">Take Photo</van-button>
      <van-button class="btn" type="primary" block @click="vibrate">Vibrate</van-button>
      <van-button class="btn" type="primary" block @click="vibrate2">Vibrate2</van-button>
      <van-button class="btn" type="primary" block @click="onGetSafeHeights">Safe Heights</van-button>
      <van-button class="btn" type="primary" block @click="setScreenHorizontal">强制/恢复横屏</van-button>
      <van-button class="btn" type="primary" block @click="setScreenPortrait">强制/恢复竖屏</van-button>
      <van-button class="btn" type="primary" block @click="notification(1, '标题', '通知内容')">通知</van-button>
      <van-button class="btn" type="primary" block
        @click="notificationAsync(2, '标题', '通知内容2，杀进程后将失效', 4)">延迟通知</van-button>
      <van-button class="btn" type="primary" block @click="ipConfig">IP Config</van-button>
      <img alt="." :src="imgSrc" style="width:calc(100vw - 80px);height: auto;" />
    </template>
  </rtm-app-container>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import { showToast, modalTips, modalConfirm, modalLoading, finishLoading, modalProgress, setProgress } from '@/rtlink-mbridge'
import { writeLocal, readLocal, scan, preDial, checkNetworkType, takePhoto, vibrate, vibrate2, getSafeHeights } from '@/rtlink-mbridge'
import { setScreenHorizontal, setScreenPortrait, notification, notificationAsync, ipConfig, getDeviceInfo } from '@/rtlink-mbridge'

// -------------------------------- controllers --------------------------------
const dm = ref([])
const imgSrc = ref()

// -------------------------------- methods --------------------------------
function onGetDeviceInfo() {
  getDeviceInfo().then((res: any) => {
    alert(JSON.stringify(res))
  })
}
function onModalTips() {
  modalTips('标题', 'ModalTips').then(() => {
    alert("您点击了 modalTips 确定")
  })
}
function onModalConfirm() {
  modalConfirm('标题', 'ModalConfirm').then(() => {
    alert("您点击了 modalConfirm 确定")
  })
}
function onModalLoading() {
  modalLoading('加载中', '请稍后...')

  setTimeout(() => {
    finishLoading().then(() => setTimeout(hell, 300))
  }, 2000)
}
function onModalProgress() {
  modalProgress('正在执行中...')
  setTimeout(() => { setProgress(30) }, 800)
  setTimeout(() => { setProgress(70) }, 1600)
  setTimeout(() => {
    setProgress(100)
  }, 2400)

  setTimeout(hell2, 3000)
}
function onReadLocal() {
  readLocal('damn', (res: any) => {
    alert(res)
  })
}
function onScan() {
  scan((res: any) => {
    alert(res)
  })
}
function onCheckNetworkType() {
  checkNetworkType().then((res: any) => {
    alert(res)
  })
}
function onTakePhoto() {
  takePhoto().then((base64Str: string) => {
    alert(base64Str)
    imgSrc.value = base64Str
  })
}
function onGetSafeHeights() {
  getSafeHeights().then((res: any) => {
    alert(`${res[0]} / ${res[1]}`)
  })
}
// ----------------------
function hell() {
  alert(' Callback function from web !!!!!! ')
}
function hell2() {
  alert('后续动作')
}
</script>

<style scoped>
button {
  margin-bottom: 20px;
}
</style>
