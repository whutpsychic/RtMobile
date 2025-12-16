// 打开App之前的逻辑处理
import SwiftUI
import AudioToolbox
import Combine

struct Preopen: View {
    @AppStorage("localUrl") var localUrl: String?
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    @State private var alreadyDone = false // 防重复触发
    @State private var showUrlPage = false // 控制是否显示sheet
    
    @State private var timeRemaining: TimeInterval = 1.2 // 倒计时
    @State private var isCancelled = false // 是否暂停跳转
    @State private var isActive = true // 控制是否还在倒计时
    
    let goto: (String?) -> Void // 路由跳转函数
    
    private func onMounted(){
        // 判断网络连接情况
        let isConnected = networkMonitor.isConnected
        // 已经联网
        if(isConnected){
            // 尝试读取本地地址
            dprint("url", localUrl as Any)
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
            goto("noNetwork")
        }
        alreadyDone = true
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                Image("logo_transp")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        isCancelled = true
                        isActive = false
                        withAnimation {
                            showUrlPage = true
                        }
                    }
                //                if isActive {
                //                    Text("将在 \(Int(timeRemaining * 10) / 10) 秒后跳转...")
                //                        .foregroundColor(.gray)
                //                        .padding(.top, 8)
                //                } else {
                //                    Text("已暂停跳转")
                //                        .foregroundColor(.red)
                //                        .padding(.top, 8)
                //                }
                Spacer()
            }.sheet(isPresented: $showUrlPage) {
                UrlConfig(isPresented: $showUrlPage, onSaveUrl: {
                    // 保存地址后，不再计时，直接跳转过去
                    goto("webview")
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
                    goto("webview")
                }
            }
        }
    }
}

#Preview {
    Preopen(goto: { route in
    })
}
