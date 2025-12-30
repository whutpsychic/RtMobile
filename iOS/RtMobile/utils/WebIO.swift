
// MARK: - 根据类型返回回到函数键
public func getfnNameByTag(_ fnName: String) -> String {
    switch fnName {
    case "scan":
        return "afterScan"
    case "getDeviceInfo":
        return "afterGetDeviceInfo"
    case "writeLocal":
        return "afterWriteLocal"
    case "readLocal":
        return "afterReadLocal"
    case "checkoutNetwork":
        return "afterCheckoutNetwork"
    case "setScreenHorizontal":
        return "afterSetScreenHorizontal"
    case "setScreenPortrait":
        return "afterSetScreenPortrait"
    default:
        return "unknown"
    }
}
