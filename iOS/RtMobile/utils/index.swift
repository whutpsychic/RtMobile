import Foundation

// 【判断网络连接状态】
// - 4g/5g 返回 4g/5g
// - wifi 返回 wifi
// - none 返回 none
public func checkoutNetwork(){
    
}

// 【检查一个url是否是合法url】
public func isValidURL(_ urlString: String) -> Bool {
    // 1. 先尝试创建 URL 对象
    guard let url = URL(string: urlString) else {
        return false
    }
    
    // 2. 检查必须包含协议（scheme）和主机（host）
    guard url.scheme != nil, url.host != nil else {
        return false
    }
    
    // 3. 可选：只允许 http 或 https
    let allowedSchemes = ["http", "https"]
    if let scheme = url.scheme?.lowercased(),
       !allowedSchemes.contains(scheme) {
        return false
    }
    
    return true
}

// 自制的调试打印
public func dprint(_ label: String, _ v: Any...){
    print(" ----------- " + label + " ----------- ")
    print(v)
}
