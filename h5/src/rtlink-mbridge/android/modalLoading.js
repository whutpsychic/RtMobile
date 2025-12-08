import { androidName, chromeErrMsg } from '../global.js'
import { insertCallbackFn } from '../utils.js'

const fnKey = `modalLoading`
const callbackFnKey = `${fnKey}Callback`

export function fn(title, content) {
  try {
    // 运行已注册函数
    window[androidName][fnKey](title, content)
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}

export function finishLoading() {
  return new Promise((reolve) => {
    // 抛送回调函数
    insertCallbackFn(callbackFnKey, reolve)
    window[androidName].finish()
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
