import { androidName, chromeErrMsg } from '../global.js'

const fnKey = `preDial`

export default function fn(numberStr) {
  try {
    // 运行已注册函数
    window[androidName][fnKey](numberStr)
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
