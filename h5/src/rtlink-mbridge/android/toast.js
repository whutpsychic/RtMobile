import { androidName, chromeErrMsg } from '../global.js'

export default function fn(content) {
  try {
    window[androidName].showToast(content)
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
