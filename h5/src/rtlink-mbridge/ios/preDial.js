import { kvSpliter, chromeErrMsg } from '../global.js'

const fnKey = `preDial`

export default async function fn(numStr) {
  return new Promise((resolve) => {
    window.webkit.messageHandlers[fnKey].postMessage(`${numStr}`)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
