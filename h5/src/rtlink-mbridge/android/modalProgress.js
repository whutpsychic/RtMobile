import { androidName, chromeErrMsg } from '../global.js'

const fnKey = `modalProgress`

export function fn(title) {
  try {
    // 运行已注册函数
    window[androidName][fnKey](title)
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}

export function setProgress(percent) {
  try {
    // 运行已注册函数
    window[androidName].setProgress(percent)
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
