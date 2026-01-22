// 获取设备信息
export const getDeviceInfo: () => Promise<string> = async () => {
  return new Promise((resolve) => {
    window.Android.getDeviceInfo()
    window.rtmobile.callbacks.afterGetDeviceInfo = resolve
  })
}

// 写入本地缓存
export const writeLocal: (k: string, v: unknown, t: number) => Promise<unknown> = async (
  key: string,
  value: unknown,
  seconds: number,
) => {
  return new Promise((resolve) => {
    window.Android.writeLocal(key, `${value}`, seconds)
    window.rtmobile.callbacks.afterWriteLocal = resolve
  })
}

// 读取本地缓存
export const readLocal: (k: string) => Promise<string> = async (key: string) => {
  return new Promise((resolve) => {
    window.Android.readLocal(key)
    window.rtmobile.callbacks.afterReadLocal = resolve
  })
}

// 拨号
export const preDial: (n: string) => void = async (number: string) => {
  window.Android.preDial(number)
}

// 检查网络连接状态
export const checkoutNetwork: () => Promise<string> = async () => {
  return new Promise((resolve) => {
    window.Android.checkoutNetwork()
    window.rtmobile.callbacks.afterCheckoutNetwork = resolve
  })
}

// 切为横屏
export const setScreenHorizontal: () => Promise<void> = async () => {
  return new Promise((resolve) => {
    window.Android.setScreenHorizontal()
    setTimeout(() => {
      resolve()
    }, 300)
  })
}

// 切为竖屏
export const setScreenPortrait: () => Promise<void> = async () => {
  return new Promise((resolve) => {
    window.Android.setScreenPortrait()
    setTimeout(() => {
      resolve()
    }, 300)
  })
}

// 混合扫码
export const scan: () => Promise<string> = async () => {
  return new Promise((resolve) => {
    window.Android.scan()
    window.rtmobile.callbacks.afterScan = resolve
  })
}
