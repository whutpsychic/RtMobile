import { getPlatform } from './utils'
// --------------------------------- Android /iOS ---------------------------------
import writeLocalA from './android/writeLocal.js'
import writeLocalI from './ios/writeLocal.js'
import readLocalA from './android/readLocal.js'
import readLocalI from './ios/readLocal.js'
import preDialA from './android/preDial.js'
import preDialI from './ios/preDial.js'
import checkNetworkTypeA from './android/checkNetworkType.js'
import checkNetworkTypeI from './ios/checkNetworkType.js'
import getDeviceInfoA from './android/getDeviceInfo.js'
import getDeviceInfoI from './ios/getDeviceInfo.js'
import getSafeHeightsA from './android/getSafeHeights.js'
import getSafeHeightsI from './ios/getSafeHeights.js'
import setScreenHorizontalA from './android/setScreenHorizontal.js'
import setScreenHorizontalI from './ios/setScreenHorizontal.js'
import setScreenPortraitA from './android/setScreenPortrait.js'
import setScreenPortraitI from './ios/setScreenPortrait.js'
import scanA from './android/scan.js'
import scanI from './ios/scan.js'

// --------------------------------- Android only ---------------------------------
// import showToast from './android/toast.js'
// import { fn as modalLoading, finishLoading } from './android/modalLoading.js'
// import { fn as modalProgress, setProgress } from './android/modalProgress.js'
// import { vibrate, vibrate2 } from './android/vibrate.js'
// import ipConfig from './android/ipConfig.js'

// --------------------------------- Android /iOS ---------------------------------
// 原生平台写入本地存储数据
export const writeLocal = async (title, content) => {
  if (getPlatform() === 'android') {
    return writeLocalA(title, content)
  } else if (getPlatform() === 'ios') {
    return writeLocalI(title, content)
  }
}

// 原生平台读取本地存储数据
export const readLocal = (key, content) => {
  if (getPlatform() === 'android') {
    return readLocalA(key, content)
  } else if (getPlatform() === 'ios') {
    return readLocalI(key, content)
  }
}

// 拨打号码
export const preDial = (numStr) => {
  if (getPlatform() === 'android') {
    return preDialA(numStr)
  } else if (getPlatform() === 'ios') {
    return preDialI(numStr)
  }
}

// 网络链接
export const checkNetworkType = () => {
  if (getPlatform() === 'android') {
    return checkNetworkTypeA()
  } else if (getPlatform() === 'ios') {
    return checkNetworkTypeI()
  }
}

// 获取设备信息
export const getDeviceInfo = () => {
  if (getPlatform() === 'android') {
    return getDeviceInfoA()
  } else if (getPlatform() === 'ios') {
    return getDeviceInfoI()
  }
}

// 获取安全高度
export const getSafeHeights = () => {
  if (getPlatform() === 'android') {
    return getSafeHeightsA()
  } else if (getPlatform() === 'ios') {
    return getSafeHeightsI()
  }
}

// 强制横屏
export const setScreenHorizontal = () => {
  if (getPlatform() === 'android') {
    return setScreenHorizontalA()
  } else if (getPlatform() === 'ios') {
    return setScreenHorizontalI()
  }
}

// 强制竖屏
export const setScreenPortrait = () => {
  if (getPlatform() === 'android') {
    return setScreenPortraitA()
  } else if (getPlatform() === 'ios') {
    return setScreenPortraitI()
  }
}

// 混合扫码
export const scan = () => {
  if (getPlatform() === 'android') {
    return scanA()
  } else if (getPlatform() === 'ios') {
    return scanI()
  }
}

// export { modalTips, modalConfirm, writeLocal, readLocal }
// export { preDial, checkNetworkType, getDeviceInfo, getSafeHeights, setScreenHorizontal, setScreenPortrait, notification }
// export { takePhoto, scan }

// // --------------------------------- Android only ---------------------------------
// export { showToast, modalLoading, finishLoading, modalProgress, setProgress }
// export { vibrate, vibrate2 }
// export { ipConfig }
// // --------------------------------------------------------------------------------
