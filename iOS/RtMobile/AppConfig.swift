import Foundation
import Combine
import SwiftUI

class AppConfig: ObservableObject {
    // 该模式下将会在各处打印一些调试信息
    @Published var developing = false // 正在开发
    
    static let spliter = "|rtm|" // 函数名和参数分隔符

    // faker
    static let apyear = 2026 // 年前
    static let apmonth = 1 // 月前
    static let apdate = 16 // 日前
    
    init() {} // 防止外部初始化
}
