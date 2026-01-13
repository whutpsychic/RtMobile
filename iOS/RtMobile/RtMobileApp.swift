import SwiftUI
import Combine

// App 入口
@main
struct MyApp: App {
    @StateObject private var appConfig = AppConfig() // app设置
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                // 初始页面
                HomePage().environmentObject(appConfig)
            }
        }
    }
}
