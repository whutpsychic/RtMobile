import { fnSpliter } from './utils'

// 通用发送函数
const postDataToiOS = (data: any): void => {
  const dataType = typeof data
  let _data
  if (dataType == 'object') {
    _data = JSON.stringify(data)
  } else {
    _data = data
  }
  try {
    window.webkit?.messageHandlers?.swiftHandler.postMessage(_data)
  } catch (err) {
    console.error(err)
  }
}

// 获取设备信息
export const getDeviceInfo: () => Promise<string> = async () => {
  return new Promise((resolve, reject) => {
    postDataToiOS(`getDeviceInfo`)
    window.rtmobile.callbacks.afterGetDeviceInfo = resolve
  })
}

// 写入本地缓存
export const writeLocal: (k: string, v: string | number, t: number) => Promise<any> = async (
  key: string,
  value: string | number,
  seconds: number,
) => {
  return new Promise((resolve, reject) => {
    postDataToiOS(`writeLocal${fnSpliter}${key}${fnSpliter}${value}${fnSpliter}${seconds}`)
    window.rtmobile.callbacks.afterWriteLocal = resolve
  })
}

// 读取本地缓存
export const readLocal: (k: string) => Promise<string> = async (key: string) => {
  return new Promise((resolve, reject) => {
    postDataToiOS(`readLocal${fnSpliter}${key}`)
    window.rtmobile.callbacks.afterReadLocal = resolve
  })
}

// 拨号
export const preDial: (n: string) => void = async (number: string) => {
  postDataToiOS(`preDial${fnSpliter}${number}`)
}

// 检查网络连接状态
export const checkoutNetwork: () => Promise<string> = async () => {
  return new Promise((resolve, reject) => {
    postDataToiOS(`checkoutNetwork`)
    window.rtmobile.callbacks.afterCheckoutNetwork = resolve
  })
}

// 切为横屏
export const setScreenHorizontal: () => Promise<void> = async () => {
  return new Promise((resolve, reject) => {
    postDataToiOS(`setScreenHorizontal`)
    setTimeout(() => {
      resolve()
    }, 300)
  })
}

// 切为竖屏
export const setScreenPortrait: () => Promise<void> = async () => {
  return new Promise((resolve, reject) => {
    postDataToiOS(`setScreenPortrait`)
    setTimeout(() => {
      resolve()
    }, 300)
  })
}

// 混合扫码
export const scan: () => Promise<string> = async () => {
  return new Promise((resolve, reject) => {
    postDataToiOS(`scan`)
    window.rtmobile.callbacks.afterScan = resolve
  })
}
