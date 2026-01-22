export const fnSpliter = '|rtm|'

/**
 * 判断当前设备是否为 iOS
 */
export function isIOS(): boolean {
  // 方案 1：检查 navigator.userAgent
  const ua = navigator.userAgent.toLowerCase()

  // 匹配 iPhone / iPod / iPad（传统方式）
  if (/iphone|ipad|ipod/.test(ua)) {
    return true
  }

  // 方案 2：应对 iPadOS 13+ 伪装成 Mac 的情况
  // iPadOS 13+ 会报告 platform 为 "MacIntel"，但支持触摸 + 最大触点数 > 1
  if (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1) {
    return true
  }

  // 方案 3：使用 platform 属性（部分环境有效）
  if (navigator.platform.includes('iPhone') || navigator.platform.includes('iPad')) {
    return true
  }

  return false
}

/**
 * 判断当前设备是否为 Android
 */
export function isAndroid(): boolean {
  if (typeof navigator === 'undefined') return false
  return /android/i.test(navigator.userAgent)
}
