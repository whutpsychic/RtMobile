import { request, getURLByType } from '@/utils'
import login from './login'

const URL: string = getURLByType(``)

// 登录
export { login }

// 《生箔机切机检查》表单提交（示例页面）（已废弃）
// export async function submitCheckoutForm(data: object) {
//   return request.post(`/equipCheckValue/v1/ReceiveCheckData`, data)
// }

