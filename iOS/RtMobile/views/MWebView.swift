import SwiftUI
import WebKit
import Combine

// 证书挑战信息结构
struct CertificateChallengeInfo {
    let challenge: URLAuthenticationChallenge
    let completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
}

// WebView 状态管理器
class WebViewManager: ObservableObject {
    @Published var progress: Double = 0.0 // 加载进度条
    @Published var isLoading: Bool = true // 网页加载中
    @Published var canGoBack: Bool = false // 网页路由可后退
    @Published var canGoForward: Bool = false // 网页路由可前进
    @Published var errorMessage: String = "" // 错误信息
    @Published var showCertificateAlert: Bool = false // 显示不信任的证书提示
    @Published var certificateChallengeInfo: CertificateChallengeInfo?
    @Published var trustedHosts: Set<String> = [] // 信任的地址
    @Published var showLoadErrorAlert: Bool = false // 显示加载错误提示
    
    @Published var receivedDataFromJS: String = "" // 接收到的来自js的数据
    weak var webView: WKWebView?
    
    init() {
        // 从存储加载已信任的服务器地址
        loadTrustedHostsFromStorage()
        showLoadErrorAlert = true
    }
    
    // 发送数据到JavaScript
    func evaluate(_ fnName:String, data: String) {
        let key: String = getfnNameByTag(fnName)
        let script = "window.rtmobile.callbacks.\(key)('\(data)')"
        webView?.evaluateJavaScript(script) { result, error in
            if let error = error {
                print("发送到JS失败: \(error)")
            } else {
                print("成功发送到JS: \(data)")
            }
        }
    }
    
    // 回调函数，用于处理来自JS的特殊命令
    var onJSCommand: ((String) -> Void)?
    
    // 接收来自JavaScript的数据
    func receiveFromJS(data: String) {
        DispatchQueue.main.async {
            self.receivedDataFromJS = data // 记录接收的信息
            self.onJSCommand?(data) // 执行方法
        }
    }
    
    // 从 UserDefaults 加载信任的主机列表
    private func loadTrustedHostsFromStorage() {
        if let data = UserDefaults.standard.data(forKey: "trustedHosts"),
           let hosts = try? JSONDecoder().decode(Set<String>.self, from: data) {
            DispatchQueue.main.async {
                self.trustedHosts = hosts
            }
        }
    }
    
    // 保存信任的主机列表到 UserDefaults
    func saveTrustedHosts() {
        if let data = try? JSONEncoder().encode(trustedHosts) {
            UserDefaults.standard.set(data, forKey: "trustedHosts")
        }
    }
    
    // 重置所有状态（可选功能）
    func resetState() {
        DispatchQueue.main.async {
            self.progress = 0.0
            self.isLoading = true
            self.canGoBack = false
            self.canGoForward = false
            self.errorMessage = ""
            self.showCertificateAlert = false
            self.certificateChallengeInfo = nil
            self.showLoadErrorAlert = false
        }
    }
}

// MWebView 组件
struct MWebView: UIViewRepresentable {
    let url: String?
    @ObservedObject var manager: WebViewManager
    
    func makeUIView(context: Context) -> WKWebView {
        // 配置WKWebView
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(context.coordinator, name: "swiftHandler")
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        context.coordinator.manager.webView = webView
        
        webView.navigationDelegate = context.coordinator
        webView.addObserver(
            context.coordinator,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: [.new],
            context: nil
        )
        
        // 启用侧滑手势
        webView.allowsBackForwardNavigationGestures = true
        
        // 只在创建时加载一次 URL
        if let urlString = url, let url = URL(string: urlString) {
            print("📱 WebView 创建，加载: \(urlString)")
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 什么都不做，即使 URL 改变也不重新加载
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(manager: manager)
    }
    
    func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        @ObservedObject var manager: WebViewManager
        
        init(manager: WebViewManager) {
            self.manager = manager
        }
        
        // 接收JavaScript消息
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "swiftHandler" {
                if let body = message.body as? String {
                    manager.receiveFromJS(data: body)
                } else if let body = message.body as? [String: Any] {
                    // 处理复杂对象
                    let jsonData = try? JSONSerialization.data(withJSONObject: body)
                    let jsonString = String(data: jsonData!, encoding: .utf8)
                    manager.receiveFromJS(data: jsonString ?? "")
                }
            }
        }
        
        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey : Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            if keyPath == "estimatedProgress", let webView = object as? WKWebView {
                DispatchQueue.main.async {
                    self.manager.progress = webView.estimatedProgress
                    self.manager.isLoading = webView.estimatedProgress < 1.0
                }
            }
        }
        
        // 监听导航状态变化
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.manager.canGoBack = webView.canGoBack
                self.manager.canGoForward = webView.canGoForward
                self.manager.isLoading = false
                self.manager.errorMessage = ""
                self.manager.showLoadErrorAlert = false // 清除错误提示
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.manager.canGoBack = webView.canGoBack
                self.manager.canGoForward = webView.canGoForward
                self.manager.isLoading = false
                if let nsError = error as NSError? {
                    if nsError.code == NSURLErrorTimedOut {
                        // 明确处理超时错误
                        self.manager.errorMessage = "页面加载超时"
                        self.manager.showLoadErrorAlert = true
                    } else if nsError.code == NSURLErrorServerCertificateUntrusted ||
                                nsError.code == NSURLErrorSecureConnectionFailed {
                        self.manager.errorMessage = "SSL证书不受信任，无法连接到服务器"
                    } else {
                        self.manager.errorMessage = "页面加载失败: \(error.localizedDescription)"
                        // 显示加载错误提示
                        self.manager.showLoadErrorAlert = true
                    }
                }
            }
        }
        
        // 处理初步导航失败（包括超时）
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.manager.canGoBack = webView.canGoBack
                self.manager.canGoForward = webView.canGoForward
                self.manager.isLoading = false
                if let nsError = error as NSError? {
                    if nsError.code == NSURLErrorTimedOut {
                        // 处理超时错误
                        self.manager.errorMessage = "页面加载超时"
                        self.manager.showLoadErrorAlert = true
                        print("页面加载超时: \(error.localizedDescription)")
                    } else if nsError.code == NSURLErrorServerCertificateUntrusted ||
                                nsError.code == NSURLErrorSecureConnectionFailed {
                        self.manager.errorMessage = "SSL证书不受信任，无法连接到服务器"
                    } else {
                        self.manager.errorMessage = "页面加载失败: \(error.localizedDescription)"
                        // 显示加载错误提示
                        self.manager.showLoadErrorAlert = true
                        print("显示加载错误提示: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        // 处理证书挑战
        func webView(
            _ webView: WKWebView,
            didReceive challenge: URLAuthenticationChallenge,
            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        ) {
            let host = challenge.protectionSpace.host
            
            // 如果主机已经在信任列表中，直接信任
            if manager.trustedHosts.contains(host) {
                print("✅ 主机 \(host) 已在信任列表中，自动信任证书")
                if let serverTrust = challenge.protectionSpace.serverTrust {
                    let credential = URLCredential(trust: serverTrust)
                    completionHandler(.useCredential, credential)
                } else {
                    completionHandler(.performDefaultHandling, nil)
                }
                return
            }
            
            // 检查是否为自签名证书错误
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
               let serverTrust = challenge.protectionSpace.serverTrust {
                
                var error: CFError?
                let isTrusted = SecTrustEvaluateWithError(serverTrust, &error)
                
                if !isTrusted {
                    // 证书不被信任，保存挑战信息并显示用户确认警告
                    DispatchQueue.main.async {
                        self.manager.certificateChallengeInfo = CertificateChallengeInfo(
                            challenge: challenge,
                            completionHandler: completionHandler
                        )
                        self.manager.showCertificateAlert = true
                    }
                    
                    // 暂时挂起请求，等待用户决定
                    return
                }
            }
            
            // 默认处理
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
