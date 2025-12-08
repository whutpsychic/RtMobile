import { kvSpliter, chromeErrMsg } from '../global.js'

const fnKey = `notification`

export default async function fn(title, content, seconds) {
  return new Promise((resolve) => {
    window.webkit.messageHandlers[fnKey].postMessage(`${title}${kvSpliter}${content}${kvSpliter}${seconds}`)
  }).catch((err) => {
    console.error(err, chromeErrMsg)
  })
}
