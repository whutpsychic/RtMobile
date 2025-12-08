import { kvSpliter, chromeErrMsg } from '../global.js'

const fnKey = `setScreenPortrait`

export default async function fn() {
  return new Promise((resolve) => {
    window.webkit.messageHandlers[fnKey].postMessage(``)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
