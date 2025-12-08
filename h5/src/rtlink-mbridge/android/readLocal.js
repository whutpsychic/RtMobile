import { androidName, chromeErrMsg } from '../global.js'
import { insertCallbackFn } from '../utils.js'

const fnKey = `readLocal`
const callbackFnKey = `${fnKey}Callback`

export default function fn(key) {
  return new Promise((resolve) => {
    // 运行已注册函数
    window[androidName][fnKey](key)
    // 绑定resolve
    insertCallbackFn(callbackFnKey, resolve)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
