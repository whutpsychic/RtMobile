// 首页
import SwiftUI

struct HomePage: View {
    @EnvironmentObject var appConfig: AppConfig // app设置
    @Environment(\.colorScheme) var colorScheme // app色系模式
    
    // 获取屏幕宽度
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // 计算推荐地址间距（也作为计算属性）
    private var spliter: CGFloat {
        (screenWidth - RecommendItemView.containerWidth * 4) / 5
    }
    
    @ObservedObject private var networkMonitor = NetworkMonitor.shared // 网络状态监听器
    @StateObject private var historyManager = HistoryManager() // 历史管理器
    @StateObject private var collectionManager = CollectionManager() // 历史管理器
    
    @State private var showNetErrAlert = false // 显示网络连接错误警告
    @State private var isScanning = false // 正在扫码
    
    @State private var urlValue: String = "" // 地址输入框的值
    @State private var pageToOpen: String? = nil // 用于编程跳转
    
    private func onMounted(){
        if(appConfig.developing){
            print(" ---- app正处于开发模式 ---- ")
        }
        // 判断网络连接情况
        let isConnected = networkMonitor.isConnected
        // 如果并未联网
        if(!isConnected){
            // 提示警告
            showNetErrAlert = true
        }
        // 等待 1 秒后执行后续代码
        Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 1秒 = 1,000,000,000 纳秒
            //            pageToOpen = "任达华"
        }
    }
    
    var body: some View {
        VStack {
            HStack{
                Text(" ")
                Spacer()
                // 扫码按钮（使用 SF Symbol 图标）
                Button(action: {
                    isScanning = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle()) // 去掉默认高亮
            }
            .padding()
            // logo图片
            Image("logo_transp")
                .resizable()          // 允许图片缩放
                .scaledToFit()        // 按比例缩放以适应可用空间（保持宽高比）
                .frame(width: 120, height: 120)
                .aspectRatio(contentMode: .fit)
            
            // 输入栏
            HStack{
                HStack{
                    TextField("请在此处输入URL", text: $urlValue)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                        .disableAutocorrection(true)
                        .submitLabel(.go)
                        .onSubmit {
                            // 用户点击“前往”时触发
                            pageToOpen = urlValue // 触发编程跳转
                        }
                    
                    // 扫码按钮（使用 SF Symbol 图标）
                    Button(action: {
                        pageToOpen = urlValue
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.blue)
                            .font(.title3)
                    }
                    .buttonStyle(PlainButtonStyle()) // 去掉默认高亮
                    .disabled(urlValue.isEmpty) // 当 urlValue 为空时禁用按钮
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(colorScheme == .dark ? Color(hex: "2F4F4F") : Color(hex: "F0FFFF"))
                .cornerRadius(200)
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
            // 上次打开的网址
            HStack{
                Text("上次打开").font(.system(size: 14))
                Spacer()
            }.padding()
            
            if (historyManager.history.first != nil){
                let item = historyManager.history.first!
                HistoryRowView(item: item){
                    pageToOpen = item.url
                }.padding()
            }else{
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                Text("暂无数据").padding()
            }
            
            // 推荐网址栏
            HStack(spacing: spliter){
                ForEach(recommendUrlList) { item in
                    RecommendItemView(url: item.url, title: item.title, char: item.firstChar){
                        pageToOpen = item.url
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, spliter)
            .padding(.top, 20)
            
            Spacer()
            
            // 快捷功能栏
            HomeNavBarView(
                // 点击收藏
                viewCollection: {
                    pageToOpen = "collections"
                },
                // 点击历史
                viewHistory: {
                    pageToOpen = "history"
                }
            )
        }
        // 编程式导航：从可选值跳转到网页页
        .navigationDestination(item: $pageToOpen) { urlString in
            // 测试页面
            if(pageToOpen == "test"){
                TestPage().navigationBarBackButtonHidden()
            }
            // 历史页面
            else if(pageToOpen == "history"){
                HistoryPage(onConfirm: { item in
                    // 回到这里后的动作
                    Task{
                        try? await Task.sleep(nanoseconds: 100_000_000) // 1秒 = 1,000,000,000 纳秒
                        pageToOpen = item.url
                    }
                })
                .environmentObject(historyManager)
            }
            // 收藏页面
            else if(pageToOpen == "collections"){
                CollectionPage(onConfirm: { item in
                    // 回到这里后的动作
                    Task{
                        try? await Task.sleep(nanoseconds: 100_000_000) // 1秒 = 1,000,000,000 纳秒
                        pageToOpen = item.url
                        historyManager.addHistory(url: item.url, title: item.title)
                    }
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
        // 【 断网警告 】
        .alert("没有网络连接",isPresented: $showNetErrAlert) {
            Button("前往设置", role: .none) {
                print("前往设置")
                openSystemSettings()
            }
            Button("好的", role: .cancel) {
                print("取消操作")
            }
        }message: {
            Text("当前设备未连接到互联网。请检查您的Wi-Fi或蜂窝数据连接，然后重试。")
        }
        // 【 扫码填充 】
        .fullScreenCover(isPresented: $isScanning) {
            CodeScannerView { result in
                urlValue = result.stringValue
                // 计算属性：自动清理后的 URL
                var cleanedUrl: String {
                    return urlValue.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                isScanning = false
            }.edgesIgnoringSafeArea(.all)
        }
        .onTapGesture {
            hideKeyboard()
        }
        // 加载完毕后
        .onAppear{
            DispatchQueue.main.async {
                onMounted()
            }
        }
    }
    
    // 隐藏键盘的辅助函数
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // 打开系统设置
    private func openSystemSettings() {
        // 尝试打开网络设置
        if let wifiSettings = URL(string: "App-Prefs:root=WIFI") {
            // 尝试打开Wi-Fi设置
            if UIApplication.shared.canOpenURL(wifiSettings) {
                UIApplication.shared.open(wifiSettings, options: [:], completionHandler: nil)
                return
            }
        }
    }
}
