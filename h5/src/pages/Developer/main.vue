<template>
  <AppCan title="原生功能" canPop>
    <div style="width: 100%;height:38px;background-color: purple;"></div>
    <!-- <img alt="Vue logo" class="logo" src="@/assets/logo.png" width="168" height="32" style="margin: 20px;" /> -->
    <div style="width: 100%;height:30px;"></div>
    <van-uploader v-model="dm" multiple></van-uploader>
    <div style="width: 100%;height:30px;"></div>
    <van-button class="btn" type="primary" block @click="onGetDeviceInfo">获取设备信息</van-button>
    <van-button class="btn" type="primary" block @click="writeLocal('damn', 'God damn it!')">WriteLocal</van-button>
    <van-button class="btn" type="primary" block @click="onReadLocal">ReadLocal</van-button>
    <van-button class="btn" type="primary" block @click="onScan">Scan Mix</van-button>
    <van-button class="btn" type="primary" block @click="preDial('18043730725')">Dial Number: 18043730725</van-button>
    <van-button class="btn" type="primary" block @click="onCheckNetworkType">NetWork Type</van-button>
    <van-button class="btn" type="primary" block @click="onGetSafeHeights">Safe Heights</van-button>
    <van-button class="btn" type="primary" block @click="setScreenHorizontal">强制/恢复横屏</van-button>
    <van-button class="btn" type="primary" block @click="setScreenPortrait">强制/恢复竖屏</van-button>
    <!-- <van-button class="btn" type="primary" block @click="ipConfig">IP Config</van-button> -->
    <img alt="." :src="imgSrc" style="width:calc(100vw - 80px); height: auto;" />
  </AppCan>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import { AppCan } from '@/views'
import { writeLocal, readLocal, scan, preDial, checkNetworkType, getSafeHeights } from '@/rtlink-mbridge/index.js'
import { setScreenHorizontal, setScreenPortrait, getDeviceInfo } from '@/rtlink-mbridge/index.js'

// -------------------------------- controllers --------------------------------
const dm = ref([])
const imgSrc = ref()

// -------------------------------- methods --------------------------------
const onGetDeviceInfo = () => {
  getDeviceInfo().then((res: any) => {
    alert(JSON.stringify(res))
  })
}

const onReadLocal = () => {
  readLocal('damn', (res: any) => {
    alert(res)
  })
}

const onScan = () => {
  scan((res: any) => {
    alert(res)
  })
}

const onCheckNetworkType = () => {
  checkNetworkType().then((res: any) => {
    alert(res)
  })
}

const onGetSafeHeights = () => {
  getSafeHeights().then((res: any) => {
    alert(`${res[0]} / ${res[1]}`)
  })
}

</script>

<style scoped>
button {
  margin-bottom: 20px;
}
</style>
