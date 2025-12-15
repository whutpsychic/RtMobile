// 打开App之前的逻辑处理
import SwiftUI


struct Preopen: View {
    @AppStorage("localUrl") var localUrl: String = ""
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    @State private var alreadyDone = false // 防重复触发
    
    @State private var showUrlPage = false // 控制是否显示sheet
    
    let onShouldNavigate: (String?) -> Void // 路由跳转函数
    
    private func onMounted(){
        // 判断网络连接情况
        let isConnected = networkMonitor.isConnected
        dprint("c?",isConnected)
        // 已经联网
        if(isConnected && !alreadyDone){
            // 尝试读取本地地址
            
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
            }
        }
    }
}

#Preview {
    Preopen(onShouldNavigate: { route in
    })
}
