import { androidName, chromeErrMsg } from '../global.js'

export function vibrate() {
  try {
    window[androidName].vibrate()
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}

export function vibrate2() {
  try {
    for (let i = 0; i < 20; i++) {
      setTimeout(() => {
        vibrate()
      }, 25 * i)
    }
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
