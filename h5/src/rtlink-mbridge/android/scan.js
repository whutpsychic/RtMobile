import { androidName, chromeErrMsg } from '../global.js'
import { insertCallbackFn } from '../utils.js'

const fnKey = `scan`
const callbackFnKey = `${fnKey}Callback`

export default function fn() {
  return new Promise((resolve) => {
    // 运行已注册函数
    window[androidName][fnKey]()
    // 绑定resolve
    insertCallbackFn(callbackFnKey, resolve)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
