import { globalRAM } from './global.js'

// 给 window 插入回调函数
export function insertCallbackFn(fnKey, fn) {
  // 预设
  if (!window[globalRAM]) window[globalRAM] = {}
  if (!window[globalRAM].callback) window[globalRAM].callback = {}
  window[globalRAM].callback[fnKey] = fn
}


// 判断当前平台
// 默认认为是Android
export function getPlatform() {
  try {
    return window[globalRAM].platform || 'android'
  }
  catch (err) {
    return 'android'
  }
}
