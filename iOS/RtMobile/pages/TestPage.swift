// 测试页面
import SwiftUI

// 主显示页 - 接收外部 WebViewManager
struct TestPage: View {
    @EnvironmentObject var appConfig: AppConfig // app设置
    @Environment(\.dismiss) private var dismiss // 获取 dismiss 环境变量
    @StateObject private var taskManager = TaskManager() // 任务管理器
    
    @State private var canFoldByScroll = false // 可以响应滑动收起底部栏了
    private let lockTaskId = UUID() // 锁定任务的唯一ID
    
    // 锁定一会儿底部栏（不能立刻）
    private func lockForAWhile() {
        taskManager.createDelayTask(
            id: lockTaskId,
            delayNanoseconds: 3_000_000_000, // 3秒
            operation: {
                canFoldByScroll = true
                print("lockForAWhile wancheng")
            }
        )
    }
    
    // 取消锁定
    private func cancelLock() {
        taskManager.cancelTask(id: lockTaskId)
    }
    
    var body: some View {
        Button("开另一个任务"){
            print("中断任务")
            cancelLock()
            lockForAWhile()
        }
        Text("Test Page")
            .onAppear {
                lockForAWhile()
            }
    }
}

