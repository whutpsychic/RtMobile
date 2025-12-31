import SwiftUI
import Combine

// 路由状态管理器
class Router: ObservableObject {
    @Published var path: NavigationPath
    
    init() {
        self.path = NavigationPath()
    }
    
    func navigate(to item: String) {
        path.append(item)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func clear() {
        path = NavigationPath()
    }
}

// App 入口
@main
struct MyApp: App {
    @StateObject private var router = Router() // 路由管理
    @StateObject private var webViewManager = WebViewManager() // webview管理
    @StateObject private var appConfig = AppConfig() // app设置
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                // 初始页面
                Preopen().environmentObject(router).environmentObject(appConfig)
                // 路由管理
                    .navigationDestination(for: String.self) { route in
                        switch route {
                        case "noNetwork":
                            NetworkError().environmentObject(router).navigationBarBackButtonHidden()
                        case "webview":
                            MainWebview(webViewManager: webViewManager).environmentObject(router).environmentObject(appConfig).navigationBarBackButtonHidden()
                                .ignoresSafeArea(edges: .top)
                        default:
                            NavigationError().environmentObject(router)
                        }
                    }
            }
        }
    }
}
