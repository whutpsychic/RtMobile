import Foundation

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

// 【检查一个url是否是合法url】
func stringToNSNumber(_ string: String) -> NSNumber {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.number(from: string)!
}

//【获取当前年份】
func getCurrentYear() -> Int {
    let calendar = Calendar.current
    let currentDate = Date()
    let year = calendar.component(.year, from: currentDate)
    return year
}

//【获取当前月份】
func getCurrentMonth() -> Int {
    let calendar = Calendar.current
    let currentDate = Date()
    let month = calendar.component(.month, from: currentDate)
    return month
}

//【获取当前日期】
func getCurrentDate() -> Int {
    let calendar = Calendar.current
    let currentDate = Date()
    let date = calendar.component(.day, from: currentDate)
    return date
}
