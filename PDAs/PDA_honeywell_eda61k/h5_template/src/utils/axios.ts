import axios from 'axios'
import { showNotify } from 'vant'
import appConfig from '@/appConfig'
import router from '@/router' // 引入路由实例

// 超时时间
const { timeout, useTempToken, tempToken } = appConfig

// 主实例
const axiosInstance = axios.create({})

// 超时时间
axiosInstance.defaults.timeout = timeout

// 请求拦截（配置发送请求的信息）
axiosInstance.interceptors.request.use(
  (config) => {
    const __token__ = useTempToken ? tempToken : localStorage.getItem(`token`)
    if (__token__) {
      config.headers.Authorization = `Bearer ${__token__}`
    }
    return config
  },
  (error) => {
    console.error(error)
  }
)

// 响应拦截（配置请求回来的信息）
axiosInstance.interceptors.response.use(
  (res) => {
    return res
  },
  (err) => {
    console.error(err)
    const { status, code } = err
    // 如果token超时，则要回到登录页
    if (status == '401') {
      router.replace('/Login')
    }

    showNotify({ type: 'danger', message: err.message })
  }
)

export default axiosInstance
