// MWebView.swift
import SwiftUI
import WebKit

struct MWebView: UIViewRepresentable {
    @AppStorage("localUrl") var localUrl: String?
    @Binding var progress: Double
    @Binding var isLoading: Bool
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
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
        if let urlString = localUrl, let url = URL(string: urlString) {
            print("📱 WebView 创建，加载: \(urlString)")
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 什么都不做，即使 URL 改变也不重新加载
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            progress: $progress,
            isLoading: $isLoading,
            canGoBack: $canGoBack,
            canGoForward: $canGoForward
        )
    }
    
    func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var progress: Double
        @Binding var isLoading: Bool
        @Binding var canGoBack: Bool
        @Binding var canGoForward: Bool
        
        init(
            progress: Binding<Double>,
            isLoading: Binding<Bool>,
            canGoBack: Binding<Bool>,
            canGoForward: Binding<Bool>
        ) {
            self._progress = progress
            self._isLoading = isLoading
            self._canGoBack = canGoBack
            self._canGoForward = canGoForward
        }
        
        override func observeValue(
            forKeyPath keyPath: String?,
            of object: Any?,
            change: [NSKeyValueChangeKey : Any]?,
            context: UnsafeMutableRawPointer?
        ) {
            if keyPath == "estimatedProgress", let webView = object as? WKWebView {
                // 👇 使用 DispatchQueue.main.async 确保在主线程更新状态
                DispatchQueue.main.async {
                    self.progress = webView.estimatedProgress
                    self.isLoading = webView.estimatedProgress < 1.0
                }
            }
        }
        
        // 监听导航状态变化
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.canGoBack = webView.canGoBack
                self.canGoForward = webView.canGoForward
                self.isLoading = false
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.canGoBack = webView.canGoBack
                self.canGoForward = webView.canGoForward
                self.isLoading = false
            }
        }
        
        // 只对特定 IP 地址信任自签名证书
        func webView(
            _ webView: WKWebView,
            didReceive challenge: URLAuthenticationChallenge,
            completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        ) {
            let host = challenge.protectionSpace.host
            let trustedIPs = ["192.168.0.11", "192.168.0.12"]
            let isTrustedHost = trustedIPs.contains(host)
            
            guard isTrustedHost else {
                completionHandler(.performDefaultHandling, nil)
                return
            }
            
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.performDefaultHandling, nil)
                return
            }
            
            var error: CFError?
            let isTrusted = SecTrustEvaluateWithError(serverTrust, &error)
            
            if isTrusted {
                completionHandler(.performDefaultHandling, nil)
            } else {
                print("⚠️ 自动信任 \(host) 的自签名证书")
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            }
        }
    }
}
