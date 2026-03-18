import { JSEncrypt } from 'jsencrypt'
import { request } from '@/utils'

const { serverURL, ports } = window

function encryptWithRsa(str: string) {
  let encrypt = new JSEncrypt()
  const key =
    'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCMnhQ99yP-eEU2jXdQWc6j-wWbqNLqOLinEGBY11WJUCmzHiEycDXPc6-3YMOvrdAiHZcjkMCzU_eRnBLUqkcNw9nhQrCak-sTpEVlAV21LskD6KMf-6PsfttUvpXeCO5g3Hg48F_vbLKxb8s_lcvQgCpKBIpsUdYRcp_PgSg8BQIDAQAB'
  encrypt.setPublicKey(key)
  return encrypt.encrypt(str)
}

// 登录
async function login(account: string, password: string) {
  return request({
    url: `${serverURL}:${ports.uc}/auth`,
    method: 'POST',
    data: {
      username: account,
      password: encryptWithRsa(password)
    }
  })
    .then((res) => {
      // 本地记录用户信息
      if (res) {
        const { data } = res
        localStorage.setItem('token', data.token)
        localStorage.setItem('account', data.account)
        localStorage.setItem('userId', data.userId)
        localStorage.setItem('username', data.username)
        return true
      } else {
        return false
      }
    })
    .catch((err) => {
      console.error(err)
      return false
    })
}

export default login
