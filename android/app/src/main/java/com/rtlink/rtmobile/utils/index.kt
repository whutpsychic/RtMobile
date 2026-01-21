package com.rtlink.rtmobile.utils

// 判断一个url字符串是否是一个合法的url
fun isValidUrl(urlStr: String): Boolean {
    val urlPattern = Regex(
        "^((https?|ftp|file)://)?([-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|])"
    )
    return urlPattern.matches(urlStr)
}

// MARK: - 根据类型返回回到函数键
fun getFnNameByTag(fnName: String): String {
    return when (fnName) {
        "scan" -> "afterScan"
        "getDeviceInfo" -> "afterGetDeviceInfo"
        "writeLocal" -> "afterWriteLocal"
        "readLocal" -> "afterReadLocal"
        "checkoutNetwork" -> "afterCheckoutNetwork"
        "setScreenHorizontal" -> "afterSetScreenHorizontal"
        "setScreenPortrait" -> "afterSetScreenPortrait"
        else -> "unknown"
    }
}
