import { kvSpliter, chromeErrMsg } from '../global.js'
import { insertCallbackFn } from '../utils.js'

const fnKey = `getSafeHeights`
const callbackFnKey = `${fnKey}Callback`

export default async function fn() {
  return new Promise((resolve) => {
    window.webkit.messageHandlers[fnKey].postMessage(``)
    // 绑定resolve
    insertCallbackFn(callbackFnKey, resolve)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
