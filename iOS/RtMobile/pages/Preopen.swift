// 打开App之前的逻辑处理
import SwiftUI
import AudioToolbox
import Combine

struct Preopen: View {
    @EnvironmentObject var router: Router // 路由
    @EnvironmentObject var appConfig: AppConfig // app设置
    
    @AppStorage("localUrl") var localUrl: String?
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    @State private var alreadyDone = false // 防重复触发
    @State private var showUrlPage = false // 控制是否显示sheet
    
    @State private var timeRemaining: TimeInterval = 1.2 // 倒计时
    @State private var isCancelled = false // 是否暂停跳转
    @State private var isActive = true // 控制是否还在倒计时
    
    @State private var progress: Double = 0.0
    
    private func onMounted(){
        if(appConfig.developing){
            print(" ---- app正处于开发模式 ---- ")
        }
        // 判断网络连接情况
        let isConnected = networkMonitor.isConnected
        // 已经联网
        if(isConnected){
            Task {
                // 模拟逐步加载
                for i in 0...100 {
                    await MainActor.run {
                        progress = Double(i) / 100.0
                    }
                    try? await Task.sleep(nanoseconds: 15_000_000) // 10ms
                }
            }
            // 如果有地址
            if let urlStr = localUrl, !urlStr.isEmpty {
                // 继续倒计时
                isActive = true
            } else {
                // 自动弹起地址配置
                showUrlPage = true
                isCancelled = true
                isActive = false
            }
        }
        // 没有网络
        else if(!alreadyDone){
            // 不再倒计时
            isActive = false
            // 前往网络错误页
            print("前往网络错误页")
            router.navigate(to: "noNetwork")
        }
        alreadyDone = true
    }
    
    var body: some View {
        VStack {
            Spacer()
            ZStack{
                CircularProgressView(progress: progress)
                Image("logo_transp")
                    .resizable()          // 允许图片缩放
                    .scaledToFit()        // 按比例缩放以适应可用空间（保持宽高比）
                    .frame(width: 120, height: 120)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        isCancelled = true
                        isActive = false
                        withAnimation {
                            showUrlPage = true
                        }
                    }
            }
            Text("Click logo image for new url")
                .padding(.vertical, 5)
            Spacer()
            Text("http://www.rtlink.com.cn").font(.system(size: 15)).foregroundColor(.black)
        }.sheet(isPresented: $showUrlPage) {
            UrlConfig(isPresented: showUrlPage,
                      onSaveUrl:{
                showUrlPage = false
                // 保存地址后，不再计时，直接跳转过去
                router.navigate(to: "webview")
            },
                      onCancel: {
                showUrlPage = false
                // 恢复计时
                isActive = true
                isCancelled = false
            })
        }
        .onAppear{
            DispatchQueue.main.async {
                onMounted()
            }
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            guard isActive && !isCancelled else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            } else {
                // 倒计时结束，触发跳转
                isActive = false
                router.navigate(to: "webview")
            }
        }
    }
}

#Preview {
    Preopen()
}
