import pkg from '../package.json'
import { isIOS, isAndroid } from './utils'
import {
  scan as scanIOS,
  getDeviceInfo as getDeviceInfoIOS,
  writeLocal as writeLocalIOS,
  readLocal as readLocalIOS,
  preDial as preDialIOS,
  checkoutNetwork as checkoutNetworkIOS,
  setScreenHorizontal as setScreenHorizontalIOS,
  setScreenPortrait as setScreenPortraitIOS,
} from './iOS'
import {
  scan as scanAndroid,
  getDeviceInfo as getDeviceInfoAndroid,
  writeLocal as writeLocalAndroid,
  readLocal as readLocalAndroid,
  preDial as preDialAndroid,
  checkoutNetwork as checkoutNetworkAndroid,
  setScreenHorizontal as setScreenHorizontalAndroid,
  setScreenPortrait as setScreenPortraitAndroid,
} from './android'

interface RTMobileBridge {
  init(): void
}

const rtm: RTMobileBridge = {
  // 初始化铺垫
  init() {
    const color1 = '#1e90ff'
    const color2 = '#fff'
    console.log(
      `%c rtlink-mbridge %c v${pkg.version} `,
      `background:${color1}; color:${color2}; padding:2px 4px; border-radius:4px 0 0 4px; border: solid 1px ${color1};`,
      `background:${color2}; color:${color1}; padding:2px 4px; border-radius:0 4px 4px 0; border: solid 1px ${color1};`,
    )
    if (!window.rtmobile) {
      window.rtmobile = {
        version: pkg.version,
        callbacks: {},
      }
    }
  },
}

// 初始化逻辑
export default rtm
export { isIOS, isAndroid }

// 【 获取设备信息 】
// -------------- iOS / Android --------------
// "deviceId": 设备唯一标识符,
// "deviceName": 设备名称,
// "systemName": 系统名称,
// "systemVersion": 系统版本号,
// "modelDisplayName": 设备型号名称,
// "screenWidth": 屏幕宽度,
// "screenHeight": 屏幕高度,
// "orientation": 当前屏幕方向（横向/竖向）,
export const getDeviceInfo: () => Promise<string> = async () => {
  if (isIOS()) {
    return getDeviceInfoIOS()
  } else if (isAndroid()) {
    return getDeviceInfoAndroid()
  } else {
    return Promise.resolve('X')
  }
}

// 【 写入本地缓存 】
// -------------- iOS / Android --------------
// 参数说明:
//  - key: 缓存键
//  - value: 缓存值
//  - seconds: 有效期默认为99年
export const writeLocal: (k: string, v: string, s?: number) => Promise<unknown> = async (
  key: string,
  value: string,
  seconds?: number,
) => {
  const validityPeriod: number = 3600 * 24 * 365 * 99
  if (isIOS()) {
    return writeLocalIOS(key, value, seconds ?? validityPeriod)
  } else if (isAndroid()) {
    return writeLocalAndroid(key, value, seconds ?? validityPeriod)
  } else {
    return Promise.resolve('X')
  }
}

// 【 读取本地缓存 】
// -------------- iOS / Android --------------
// 参数说明:
//  - key: 缓存键
// 如果数据过期或不存在则读取结果为""
export const readLocal: (k: string) => Promise<string> = async (key: string) => {
  if (isIOS()) {
    return readLocalIOS(key)
  } else if (isAndroid()) {
    return readLocalAndroid(key)
  } else {
    return Promise.resolve('X')
  }
}

// 【 拨打电话 】
// -------------- iOS / Android --------------
export const preDial: (n: string) => void = async (number: string) => {
  if (isIOS()) {
    return preDialIOS(number)
  } else if (isAndroid()) {
    return preDialAndroid(number)
  } else {
    return
  }
}

// 【 检查网络连接 】
// -------------- iOS --------------
// 可能得到的结果:
// ['Wifi', 'Cellular', 'Ethernet', 'Loopback', 'Connected', 'Disconnected']
// -------------- Android --------------
// 可能得到的结果:
// ['WIFI', 'MOBILE', 'BLUETOOTH', 'ETHERNET', 'VPN', 'null']
export const checkoutNetwork: () => Promise<string> = async () => {
  if (isIOS()) {
    return checkoutNetworkIOS()
  } else if (isAndroid()) {
    return checkoutNetworkAndroid()
  } else {
    return Promise.resolve('X')
  }
}

// 【 切为横屏 】
// -------------- iOS / Android --------------
export const setScreenHorizontal: () => Promise<void> = async () => {
  if (isIOS()) {
    return setScreenHorizontalIOS()
  } else if (isAndroid()) {
    return setScreenHorizontalAndroid()
  } else {
    return Promise.resolve()
  }
}

// 【 切为竖屏 】
// -------------- iOS / Android --------------
export const setScreenPortrait: () => Promise<void> = async () => {
  if (isIOS()) {
    return setScreenPortraitIOS()
  } else if (isAndroid()) {
    return setScreenPortraitAndroid()
  } else {
    return Promise.resolve()
  }
}

// 【 混合扫码 】
// -------------- iOS / Android --------------
// 支持的码类型
// .qr,
// .code128,
// .code39,
// .code93,
// .pdf417,
// .ean13,
// .ean8,
// .upce,
// .dataMatrix
export const scan: () => Promise<string> = async () => {
  if (isIOS()) {
    return scanIOS()
  } else if (isAndroid()) {
    return scanAndroid()
  } else {
    return Promise.resolve('X')
  }
}
