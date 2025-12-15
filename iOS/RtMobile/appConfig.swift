import Foundation
import Combine
import SwiftUI

class GlobalState: ObservableObject {
    static let shared = GlobalState()

    // 该模式下将会在各处打印一些调试信息
    @Published var developing = true // 正在开发
    
    private init() {} // 防止外部初始化
}
