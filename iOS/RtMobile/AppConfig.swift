import Foundation
import Combine
import SwiftUI

class AppConfig: ObservableObject {
    // 该模式下将会在各处打印一些调试信息
    @Published var developing = true // 正在开发
    
    init() {} // 防止外部初始化
}
