// 主显示页
import SwiftUI
import WebKit

// 主显示页 - 接收外部 WebViewManager
struct WebviewPage: View {
    @EnvironmentObject var appConfig: AppConfig // app设置
    @Environment(\.dismiss) private var dismiss // 获取 dismiss 环境变量
    
    let url: String // 地址
    
    @StateObject private var webViewManager = WebViewManager() // webview管理
    @State private var isScanning: Bool = false // 正在扫码
    @State private var scannedResult: String? // 扫码结果
    @State private var showMore: Bool = false // 显示更多操作
    @State private var collecting: Bool = false // 正在进行收藏编辑
    @State private var viewingHistory: Bool = false // 显示历史列表视图
    @StateObject private var cacheManager = LocalCacheManager.shared
    
    @State private var firstLoad = true // 首次加载
    @State private var pageToOpen: String? = nil // 用于编程跳转
    
    // 底部导航条相关
    @State private var navBarVisible = true
    @State private var canFoldByScroll = false // 可以响应滑动收起底部栏了
    @StateObject private var taskManager = TaskManager() // 任务管理器
    
    @StateObject private var historyManager = HistoryManager() // 历史管理器
    @StateObject private var collectionManager = CollectionManager() // 收藏管理器
    
    private let lockTaskId = UUID() // 锁定任务的唯一ID
    // 计算属性：后退是否可用
    private var canGoBack: Bool {
        webViewManager.canGoBack
    }
    // 计算属性：前进是否可用
    private var canGoForward: Bool {
        webViewManager.canGoForward
    }
    
    // 计算属性：两个条件同时为 true 时才显示
    private var shouldShowErrorCover: Bool {
        webViewManager.showLoadErrorAlert && firstLoad
    }
    
    // 返回
    private func goBack(){
        webViewManager.showCertificateAlert = false
        webViewManager.showLoadErrorAlert = false
        dismiss()
    }
    
    // 锁定一会儿底部栏（不能立刻）
    private func lockForAWhile() {
        canFoldByScroll = false
        taskManager.createDelayTask(
            id: lockTaskId,
            delayNanoseconds: 3_000_000_000, // 3秒
            operation: {
                canFoldByScroll = true
            }
        )
    }
    
    // 安全区域计算属性（iOS 15+ 兼容）
    private var safeAreaInsets: UIEdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return window.safeAreaInsets
        }
        return .zero
    }
    
    var body: some View {
        ZStack {
            // MWebView 组件
            MWebView(url: url, manager: webViewManager){
                lockForAWhile()
            }
            .ignoresSafeArea() // 仅忽略所有安全区域，不指定edges
            .onReceive(webViewManager.$hasScrolled) { hasScrolled in
                if hasScrolled {
                    if(canFoldByScroll){
                        navBarVisible = false
                    }
                }
            }
            
            VStack{
                Spacer()
                // 底部条
                BottomNavigationBar(
                    visible: navBarVisible,
                    loading: webViewManager.isLoading,
                    progress: webViewManager.progress,
                    canGoBack: canGoBack,
                    canGoForward: canGoForward,
                    onPressBack: { webViewManager.goBack() },
                    onPressForward: { webViewManager.goForward() },
                    onPressHome: { dismiss() },
                    onPressRefresh: { webViewManager.refresh() },
                    onPressMore: {
                        showMore = true
                    },
                    onExpand: {
                        navBarVisible = true
                        lockForAWhile()
                    },
                )
            }
        }
        .ignoresSafeArea() // 仅忽略所有安全区域，不指定edges
        .onChange(of: webViewManager.showCertificateAlert) {
            // 弹窗关闭时，处理用户选择
            if !webViewManager.showCertificateAlert {
                // 这里处理弹窗关闭的逻辑，但实际处理在alert的按钮中
            }
        }
        .onAppear {
            firstLoad = false
            setupJsTunnel()
            // 记录历史
            webViewManager.getCurrentWebTitle(completion: { title in
                historyManager.addHistory(url: url, title: title ?? url)
            })
        }
        // 【 更多操作 】
        .sheet(isPresented: $showMore){
            List{
                Section("操作"){
                    FormButton("收藏", "star"){
                        showMore = false
                        collecting = true
                    }
                }
                Section("查看"){
                    FormButton("历史记录"){
                        showMore = false
                        pageToOpen = "history"
                    }
                    FormButton("我的收藏"){
                        showMore = false
                        pageToOpen = "collections"
                    }
                }
            }
            .presentationDetents([.medium, .large]) // 可以选择 .fraction(0.5), .height(300) 等
            .presentationDragIndicator(.automatic) // 显示拖拽指示器
        }
        .sheet(isPresented: $collecting){
            PreCollectView(
                url: url,
                onCancel: {
                    collecting = false
                },
                onConfirm: { url, title in
                    collecting = false
                    // 添加到收藏
                    collectionManager.addCollection(url: url, title: title)
                }
            )
            .presentationDetents([.medium])
        }
        // 编程式导航：从可选值跳转到网页页
        .navigationDestination(item: $pageToOpen) { urlString in
            // 历史页面
            if(pageToOpen == "history"){
                HistoryPage(onConfirm: { item in
                    // 回到这里后的动作
                })
                .environmentObject(historyManager)
            }
            else if(pageToOpen == "collections"){
                CollectionPage(onConfirm: { item in
                    // 回到这里后的动作
                })
                .environmentObject(collectionManager)
            }
            // 前往页面
            else{
                // 分析是否是一个合法的url
                let isValid: Bool = isValidURL(urlString)
                // 是的话正常前往
                if(isValid){
                    WebviewPage(url: urlString).environmentObject(appConfig).navigationBarBackButtonHidden()
                }
                // 否则使用百度搜索
                else{
                    WebviewPage(url: "https://www.baidu.com/s?wd=\(urlString)").environmentObject(appConfig).navigationBarBackButtonHidden()
                }
            }
        }
        // 【 加载失败提示 】
        .fullScreenCover(isPresented: .constant(shouldShowErrorCover)){
            WebviewLoadFailedView(errorMessage: webViewManager.errorMessage){
                goBack()
            }
        }
        // 【 自签名确认提示 】
        .fullScreenCover(isPresented: $webViewManager.showCertificateAlert) {
            CustomHttpsConfirm(webViewManager: webViewManager){
                goBack()
            }
        }
        // 【 正在扫码 】
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
    
    // 设置js通道
    private func setupJsTunnel(){
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
}

// 【 收藏前编辑动作 】
struct PreCollectView: View{
    let url: String
    let onCancel: () -> Void
    let onConfirm: (_ serverUrl: String, _ serverRemark: String) -> Void
    
    @State private var serverRemark: String = ""
    @State private var serverUrl: String = ""
    
    var body: some View{
        VStack {
            HStack{
                Button("取消"){
                    onCancel()
                }
                Spacer()
                Button("完成"){
                    onConfirm(serverUrl, serverRemark)
                }
            }.padding()
            List{
                TextField("请输入服务器备注", text: $serverRemark)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                TextField("地址", text: $serverUrl)
                    .disabled(true)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear{
            serverUrl = url
        }
    }
}


// 【 加载失败提示 】
struct WebviewLoadFailedView: View{
    
    let errorMessage: String
    let goBack: () -> Void
    
    var body: some View{
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("加载失败")
                .font(.title)
                .padding(.top, 10)
            
            Text(errorMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("重试") {
                goBack()
            }
            .padding(.top, 20)
            
            Button("配置地址") {
                goBack()
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// 【 自签名确认提示 】
struct CustomHttpsConfirm: View{
    
    let webViewManager: WebViewManager
    let goBack: () -> Void
    
    var body: some View{
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
                goBack()
            }
            Spacer()
        }
        .padding(.top, 5)
        Spacer()
    }
}






