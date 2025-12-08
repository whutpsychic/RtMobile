import { androidName, chromeErrMsg } from '../global.js'

export default function fn(title, content, seconds) {
  try {
    const id = Date.now()
    window[androidName].notification(id, title, content, seconds)
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
