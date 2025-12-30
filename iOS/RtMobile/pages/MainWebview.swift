// 主显示页
import SwiftUI
import WebKit

// 主显示页 - 接收外部 WebViewManager
struct MainWebview: View {
    @EnvironmentObject var router: Router // 路由
    @EnvironmentObject var appConfig: AppConfig // app设置
    
    @AppStorage("localUrl") var localUrl: String?
    @ObservedObject var webViewManager: WebViewManager
    @State private var isScanning: Bool = false // 正在扫码
    @State private var scannedResult: String? // 扫码结果
    @StateObject private var cacheManager = LocalCacheManager.shared
    
    var body: some View {
        ZStack {
            // MWebView 组件
            MWebView(url: localUrl, manager: webViewManager)
            // 进度条 - 居于屏幕顶端并添加margin-top
            if webViewManager.isLoading {
                VStack {
                    ProgressView(value: webViewManager.progress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding(.top, 2) // 添加顶部间距
                        .frame(maxWidth: .infinity) // 确保宽度占满
                    Spacer() // 占据剩余空间
                    // 转圈圈加载动画
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .scaleEffect(2.0) // 可选：调整大小
                        .padding()
                    Spacer() // 占据剩余空间
                }
            }
        }
        .onChange(of: webViewManager.showCertificateAlert) {
            // 弹窗关闭时，处理用户选择
            if !webViewManager.showCertificateAlert {
                // 这里处理弹窗关闭的逻辑，但实际处理在alert的按钮中
            }
        }
        .onAppear {
            // 设置回调函数，让WebViewManager可以更新isScanning状态
            webViewManager.onJSCommand = { command in
                if(appConfig.developing){
                    print(" ----------- received data from js -----------")
                    print(command)
                }
                
                let transData = command.split(separator: AppConfig.spliter)
                let fnName = transData[0]
                
                // 混合扫码
                if fnName == "scan" {
                    DispatchQueue.main.async {
                        self.isScanning = true
                    }
                }
                // 获取设备信息
                else if fnName == "getDeviceInfo"{
                    DeviceInfo.printAll()
                    let infoString = DeviceInfo.getAllInfo()
                    webViewManager.evaluate("getDeviceInfo", data: "\(infoString)")
                }
                // 写入本地缓存
                else if fnName == "writeLocal"{
                    let key: String = String(transData[1])
                    let value: String = String(transData[2])
                    let seconds: NSNumber = stringToNSNumber(String(transData[3]))
                    
                    let timeInterval: TimeInterval = seconds.doubleValue
                    cacheManager.set(value, forKey: key, expirationTime: timeInterval)
                    
                    webViewManager.evaluate("writeLocal", data: "true")
                    if(appConfig.developing){
                        print(" ------- 已成功写入缓存\(key)，值为\(value)，有效期为\(String(describing: seconds))秒 ------- ")
                    }
                }
                // 读取本地缓存
                else if fnName == "readLocal"{
                    let key: String = String(transData[1])
                    let value: String? = cacheManager.get(key)
                    webViewManager.evaluate("readLocal", data: "\(value ?? "")")
                    if(appConfig.developing){
                        print(" ------- 已成功读取缓存\(key)，值为\(value ?? "") ------- ")
                    }
                }
                // 电话拨号
                else if fnName == "preDial"{
                    let number: String = String(transData[1])
                    // 打开电话应用
                    UIApplication.shared.open(URL(string: "tel:\(number)")!)
                }
                // 检查网络连接状态
                else if fnName == "checkoutNetwork"{
                    let type: String = NetworkMonitor.shared.connectionType
                    if(appConfig.developing){
                        print(" ------- 当前网络连接类型为\(type) ------- ")
                    }
                    webViewManager.evaluate("checkoutNetwork", data: "\(type)")
                }
                // 切为横屏
                else if fnName == "setScreenHorizontal"{
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    // .portrait / .landscapeLeft / .landscapeRight / .portraitUpsideDown
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
                    if(appConfig.developing){
                        print(" ------- 已将屏幕切为横屏 ------- ")
                    }
                }
                // 切为竖屏
                else if fnName == "setScreenPortrait"{
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    // .portrait / .landscapeLeft / .landscapeRight / .portraitUpsideDown
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                    if(appConfig.developing){
                        print(" ------- 已将屏幕切为竖屏 ------- ")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $webViewManager.showCertificateAlert) {
            Spacer()
            Text("该地址使用的是未受信任的机构颁发的证书或自签名证书，您确认要信任该服务器地址吗？")
                .padding(.horizontal, 20)
            HStack{
                Spacer()
                Text("您可以选择")
                Button("继续前往") {
                    // 用户选择继续，信任该主机
                    if let challengeInfo = webViewManager.certificateChallengeInfo {
                        let host = challengeInfo.challenge.protectionSpace.host
                        webViewManager.trustedHosts.insert(host)
                        webViewManager.saveTrustedHosts() // 保存到持久存储
                        
                        // 调用completionHandler信任证书
                        if let serverTrust = challengeInfo.challenge.protectionSpace.serverTrust {
                            let credential = URLCredential(trust: serverTrust)
                            challengeInfo.completionHandler(.useCredential, credential)
                        }
                        
                        // 清空挑战信息
                        webViewManager.certificateChallengeInfo = nil
                        webViewManager.showCertificateAlert = false
                    }
                }
                Text("或者")
                Button("返回") {
                    // 清除之前的url并返回重新输入
                    localUrl = nil
                    webViewManager.showCertificateAlert = false
                    router.goBack()
                }
                Spacer()
            }
            .padding(.top, 5)
            Spacer()
        }
        .fullScreenCover(isPresented: $isScanning) {
            CodeScannerView { result in
                scannedResult = result.stringValue
                // 触发回调
                if(scannedResult != nil){
                    webViewManager.evaluate("scan", data: "\(scannedResult!)")
                }
                isScanning = false
            }.edgesIgnoringSafeArea(.all)
        }
    }
}
