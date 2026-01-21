package com.rtlink.rtmobile

// 开发模式下：
// 部分环节有输出信息
const val developing: Boolean = true // 开发模式

const val IO_NAME: String = "Android" // web端JS调用原生接口时的对象名字

const val RAM_NAME: String = "rtmobile" // RAM名称

const val spliter: String = "|rtm|" // 函数名和参数分隔符

// 离线模式下：
// 不再监听网络连接状态
// 直接加载本地html
const val offlineMode: Boolean = false // 离线模式
