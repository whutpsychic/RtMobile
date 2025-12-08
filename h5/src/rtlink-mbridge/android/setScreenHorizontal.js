import { androidName, chromeErrMsg } from '../global.js'

export default function fn() {
  try {
    window[androidName].setScreenHorizontal()
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
