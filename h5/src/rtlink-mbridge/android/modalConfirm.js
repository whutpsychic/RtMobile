import { androidName, chromeErrMsg } from '../global.js'
import { insertCallbackFn } from '../utils.js'

const fnKey = `modalConfirm`
const callbackFnKey = `${fnKey}Callback`

export default function fn(title, content) {
  return new Promise((resolve) => {
    // 运行已注册函数
    window[androidName][fnKey](title, content)
    // 绑定resolve
    insertCallbackFn(callbackFnKey, resolve)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
