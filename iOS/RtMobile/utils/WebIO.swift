// 根据类型返回回到函数键
public func getfnNameByTag(_ fnName: String) -> String {
    switch fnName {
    case "scan":
        return "afterScan"
    case "scan2":
        return "afterScan2"
    default:
        return "xxxx"
    }
}
