import pkg from '../package.json'
import { scan as scanIOS } from './iOS'
import { isIOS, isAndroid } from './utils'

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

export const scan: () => Promise<String | undefined> = async () => {
  if (isIOS()) {
    return scanIOS()
  } else if (isAndroid()) {
    return Promise.resolve('X')
  }
}
