import { kvSpliter, chromeErrMsg } from '../global.js'
import { insertCallbackFn } from '../utils.js'

const fnKey = `writeLocal`
const callbackFnKey = `${fnKey}Callback`

export default async function fn(key, content) {
  return new Promise((resolve) => {
    window.webkit.messageHandlers[fnKey].postMessage(`${key}${kvSpliter}${content}`)
    // 绑定resolve
    insertCallbackFn(callbackFnKey, resolve)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
