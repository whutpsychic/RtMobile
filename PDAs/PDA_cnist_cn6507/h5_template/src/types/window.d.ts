// 服务器端口号
interface windowPorts {
  // 登录相关
  uc: string
  // 文件相关
  file: string
  // 默认使用
  base: string
}

interface Window {
  // 服务器地址
  serverURL: string
  // 服务器端口号
  ports: windowPorts
}
