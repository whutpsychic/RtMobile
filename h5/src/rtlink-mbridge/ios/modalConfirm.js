import { kvSpliter, chromeErrMsg } from '../global.js'
import { insertCallbackFn } from '../utils.js'

const fnKey = `modalConfirm`
const callbackFnKey = `${fnKey}Callback`

export default async function fn(title, content) {
  return new Promise((resolve) => {
    window.webkit.messageHandlers[fnKey].postMessage(`${title}${kvSpliter}${content}`)
    // 绑定resolve
    insertCallbackFn(callbackFnKey, resolve)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
