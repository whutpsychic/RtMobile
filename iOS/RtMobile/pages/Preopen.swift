// 打开App之前的逻辑处理
import SwiftUI
import AudioToolbox

struct Preopen: View {
    @AppStorage("localUrl") var localUrl: String?
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    @State private var alreadyDone = false // 防重复触发
    
    @State private var showUrlPage = false // 控制是否显示sheet
    
    let onShouldNavigate: (String?) -> Void // 路由跳转函数
    
    private func onMounted(){
        // 判断网络连接情况
        let isConnected = networkMonitor.isConnected
        // 已经联网
        if(isConnected){
            // 尝试读取本地地址
            dprint("url", localUrl as Any)
            // 如果有地址
            if let urlStr = localUrl, !urlStr.isEmpty {
                print("有有效内容：\(urlStr)")
                // 前往页面
            } else {
                print("是 nil 或空字符串")
                // 自动弹起地址配置
                showUrlPage = true
            }
        }
        // 没有网络
        else if(!alreadyDone){
            // 前往网络错误页
            onShouldNavigate("noNetwork")
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
                        withAnimation {
                            showUrlPage = true
                        }
                    }
                Spacer()
            }.sheet(isPresented: $showUrlPage) {
                UrlConfig(isPresented: $showUrlPage)
            }
            .onAppear{
                DispatchQueue.main.async {
                    onMounted()
                }
                print("onAppear")
            }
        }
    }
}

#Preview {
    Preopen(onShouldNavigate: { route in
    })
}
