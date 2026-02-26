import request from './axios'
export { request }

// 登录相关:login
// 文件相关:file
// 默认使用:default
export function getURLByType(type: string | undefined) {
  // 请求地址
  const { serverURL, ports } = window
  switch (type) {
    case `login`:
      return `${serverURL}:${ports.uc}`
    case `file`:
      return `${serverURL}:${ports.file}`
    default:
      return `${serverURL}:${ports.base}`
  }
}

// 简易深克隆
export function deepClone(obj: any) {
  try {
    const str = JSON.stringify(obj)
    return JSON.parse(str)
  } catch (err) {
    console.error(err)
  } finally {
  }
}
