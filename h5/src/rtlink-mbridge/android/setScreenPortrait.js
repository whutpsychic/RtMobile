import { androidName, chromeErrMsg } from '../global.js'

export default function fn() {
  try {
    window[androidName].setScreenPortrait()
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
