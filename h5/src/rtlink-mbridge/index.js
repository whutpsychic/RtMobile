import { getPlatform } from './utils'
// --------------------------------- Android /iOS ---------------------------------
import modalTipsA from './android/modalTips.js'
import modalTipsI from './ios/modalTips.js'
import modalConfirmA from './android/modalConfirm.js'
import modalConfirmI from './ios/modalConfirm.js'
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
import notificationA from './android/notification.js'
import notificationI from './ios/notification.js'
import takePhotoA from './android/takePhoto.js'
import takePhotoI from './ios/takePhoto.js'
import scanA from './android/scan.js'
import scanI from './ios/scan.js'

// --------------------------------- Android only ---------------------------------
import showToast from './android/toast.js'
import { fn as modalLoading, finishLoading } from './android/modalLoading.js'
import { fn as modalProgress, setProgress } from './android/modalProgress.js'
import { vibrate, vibrate2 } from './android/vibrate.js'
import ipConfig from './android/ipConfig.js'

// 原生平台 alert 提示
async function modalTips(title, content) {
  if (getPlatform() === 'android') {
    return modalTipsA(title, content)
  } else if (getPlatform() === 'ios') {
    return modalTipsI(title, content)
  }
}

// 原生平台 confirm 确认
async function modalConfirm(title, content) {
  if (getPlatform() === 'android') {
    return modalConfirmA(title, content)
  } else if (getPlatform() === 'ios') {
    return modalConfirmI(title, content)
  }
}

// 原生平台写入本地存储数据
async function writeLocal(title, content) {
  if (getPlatform() === 'android') {
    return writeLocalA(title, content)
  } else if (getPlatform() === 'ios') {
    return writeLocalI(title, content)
  }
}

// 原生平台读取本地存储数据
async function readLocal(key, content) {
  if (getPlatform() === 'android') {
    return readLocalA(key, content)
  } else if (getPlatform() === 'ios') {
    return readLocalI(key, content)
  }
}

// 拨打号码
async function preDial(numStr) {
  if (getPlatform() === 'android') {
    return preDialA(numStr)
  } else if (getPlatform() === 'ios') {
    return preDialI(numStr)
  }
}

// 网络链接
async function checkNetworkType() {
  if (getPlatform() === 'android') {
    return checkNetworkTypeA()
  } else if (getPlatform() === 'ios') {
    return checkNetworkTypeI()
  }
}

// 获取设备信息
async function getDeviceInfo() {
  if (getPlatform() === 'android') {
    return getDeviceInfoA()
  } else if (getPlatform() === 'ios') {
    return getDeviceInfoI()
  }
}

// 获取安全高度
async function getSafeHeights() {
  if (getPlatform() === 'android') {
    return getSafeHeightsA()
  } else if (getPlatform() === 'ios') {
    return getSafeHeightsI()
  }
}

// 强制横屏
async function setScreenHorizontal() {
  if (getPlatform() === 'android') {
    return setScreenHorizontalA()
  } else if (getPlatform() === 'ios') {
    return setScreenHorizontalI()
  }
}

// 强制竖屏
async function setScreenPortrait() {
  if (getPlatform() === 'android') {
    return setScreenPortraitA()
  } else if (getPlatform() === 'ios') {
    return setScreenPortraitI()
  }
}

// 本地通知
async function notification(title, content, seconds = 2) {
  if (getPlatform() === 'android') {
    return notificationA(title, content, seconds)
  } else if (getPlatform() === 'ios') {
    return notificationI(title, content, seconds)
  }
}

// 相机拍照（返回base64字符串）
async function takePhoto() {
  if (getPlatform() === 'android') {
    return takePhotoA()
  } else if (getPlatform() === 'ios') {
    return takePhotoI()
  }
}

// 混合扫码
async function scan() {
  if (getPlatform() === 'android') {
    return scanA()
  } else if (getPlatform() === 'ios') {
    return scanI()
  }
}

// --------------------------------- Android /iOS ---------------------------------
export { modalTips, modalConfirm, writeLocal, readLocal }
export { preDial, checkNetworkType, getDeviceInfo, getSafeHeights, setScreenHorizontal, setScreenPortrait, notification }
export { takePhoto, scan }

// --------------------------------- Android only ---------------------------------
export { showToast, modalLoading, finishLoading, modalProgress, setProgress }
export { vibrate, vibrate2 }
export { ipConfig }
// --------------------------------------------------------------------------------
