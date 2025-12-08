import { androidName, chromeErrMsg } from '../global.js'

export default function fn() {
  try {
    window[androidName].ipConfig()
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
