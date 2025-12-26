// url配置页
import SwiftUI

struct UrlConfig: View {
    @Binding var isPresented: Bool // 用于返回（可选）
    @AppStorage("localUrl") var serverUrl: String = "https://"
    
    @State private var isScanning: Bool = false // 正在扫码
    @State private var showAlert: Bool = false // 显示错误提示
    // 表单数据
    @State private var useHttps = true
    
    @State private var scannedResult: String? // 扫码结果
    
    // 当网络恢复时的回调函数
    let onSaveUrl: () -> Void
    
    // 将头部http模式换掉
    private func changeUrlHeadByType(useHttps:Bool){
        if(useHttps){
            if serverUrl.hasPrefix("http://") {
                let result = serverUrl.replacingOccurrences(of: "http://", with: "https://")
                serverUrl = result
            }
            if(!serverUrl.contains("https://")){
                serverUrl = "https://" + serverUrl
            }
        }else{
            if serverUrl.hasPrefix("https://") {
                let result = serverUrl.replacingOccurrences(of: "https://", with: "http://")
                serverUrl = result
            }
            if(!serverUrl.contains("http://")){
                serverUrl = "http://" + serverUrl
            }
        }
    }
    
    // 开始扫码
    private func startScanning(){
        isScanning = true
    }
    
    // 点击保存
    private func onSave(){
        // 这里可以保存到 UserDefaults 或 AppSettings
        print("保存 URL: \(serverUrl)")
        // 合法地址
        if(isValidURL(serverUrl)){
            // 收起面板
            isPresented = false
            // 保存到本地
            UserDefaults.standard.set(serverUrl, forKey: "localUrl")
            onSaveUrl() // 回调
        }
        // 非法地址
        else{
            // 提示
            showAlert = true
        }
    }
    
    var body: some View {
        VStack {
            // 顶部按钮
            HStack{
                Button("取消") {
                    isPresented = false
                }
                .foregroundColor(.primary)
                Spacer()
                Text("URL 配置").fontWeight(.bold)
                Spacer()
                Button("保存") {
                    onSave()
                }
                .fontWeight(.semibold)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            .background(Color.clear) // 透明背景
            // 主表单
            Form {
                Section("服务器地址") {
                    HStack{
                        TextField("请输入 URL", text: $serverUrl)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .disableAutocorrection(true)
                        
                        // 扫码按钮（使用 SF Symbol 图标）
                        Button(action: {
                            // 这里处理扫码逻辑
                            print("开始扫码...")
                            startScanning()
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle()) // 去掉默认高亮
                    }
                }
                
                Section("连接选项") {
                    Toggle("使用 HTTPS", isOn: $useHttps)
                        .onChange(of: useHttps) { oldValue, newValue in
                            // iOS 17+ 语法（两个参数）
                            changeUrlHeadByType(useHttps: newValue)
                        }
                    //                        Picker("超时时间 (秒)", selection: $timeout) {
                    //                            ForEach([10, 20, 30, 60], id: \.self) { seconds in
                    //                                Text("\(seconds) 秒").tag(seconds)
                    //                            }
                    //                        }
                    //                        .pickerStyle(MenuPickerStyle()) // 弹出菜单样式（iOS 风格）
                }
            }
            .fullScreenCover(isPresented: $isScanning) {
                CodeScannerView { result in
                    scannedResult = result.stringValue
                    // 计算属性：自动清理后的 URL
                    var cleanedUrl: String {
                        return scannedResult!.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if(useHttps){
                        if(!(cleanedUrl.contains("https://"))){
                            serverUrl = "https://" + cleanedUrl
                        }
                        else{
                            serverUrl = cleanedUrl
                        }
                    }
                    else{
                        if(!(cleanedUrl.contains("http://"))){
                            serverUrl = "http://" + cleanedUrl
                        }
                        else{
                            serverUrl = cleanedUrl
                        }
                    }
                    isScanning = false
                }.edgesIgnoringSafeArea(.all)
            }
        }
        .alert("警告", isPresented: $showAlert) {
            Button("重新输入", role: .cancel) { }
        } message: {
            Text("不正确的地址").padding()
        }
    }
}

#Preview {
    Preopen()
}
