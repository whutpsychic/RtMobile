import { androidName, chromeErrMsg } from '../global.js'
import { insertCallbackFn } from '../utils.js'

const fnKey = `modalTips`
const callbackFnKey = `${fnKey}Callback`

export default async function fn(title, content) {
  return new Promise((resolve) => {
    // 运行已注册函数
    window[androidName][fnKey](title, content)
    // 绑定resolve
    insertCallbackFn(callbackFnKey, resolve)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
