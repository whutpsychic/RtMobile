export default {
  // 调试模式
  // 当处在调试模式下将会有以下特性
  // - 除导航页外，所有页面皆可后退
  // - 《登录页》自动填充测试用户名密码
  // - 《首页》自动填充测试设备名
  // - useTempToken 开启时接口带入默认token
  developing: true,
  
  // 测试时自动填充的用户名和密码
  testUsername: "admin",
  testUserpsw: "123456",

  // 免登录(仅测试时，即 developing 为 true 时有效)
  nologin: false,

  // 网络请求超时时间：10s
  timeout: 10 * 1000,

  // 使用临时token
  useTempToken: false,
  
  // 调试用token
  tempToken:
    'f7bGjEchE6FPrindSYCesGSekwowUrPBWmIFQunFurID+xEABryTPfW9vZ6TaNi7oddIZ5lU1v8E3gYHOXGm7/oXMnmtroBQ8J7eZ+Gw6Pfq1tS6UjSiIFbvans+MW5mbaWA627TWpT25TonOQoz7WsGiVm56JHaaVzWlcdA6FE='
}
