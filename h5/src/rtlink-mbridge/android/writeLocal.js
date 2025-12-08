import { androidName, chromeErrMsg } from '../global.js'

const fnKey = `writeLocal`

export default function fn(key, value) {
  try {
    // 运行已注册函数
    window[androidName][fnKey](key, value)
  } catch (err) {
    console.error(err, chromeErrMsg)
  }
}
