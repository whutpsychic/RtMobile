// 网络错误页
// 监听网络连接变化，当恢复网络时回退到主前置页

import SwiftUI

struct NetworkError: View {
    @EnvironmentObject var router: Router
    @ObservedObject private var networkMonitor = NetworkMonitor.shared
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("无法连接到互联网")
                .font(.title)
                .fontWeight(.bold)
            
            Text("请检查您的网络连接，然后重试。")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .foregroundColor(.secondary)
        }
        .onReceive(networkMonitor.$isConnected) { isConnected in
            // 判断网络连接情况
            if isConnected  {
                router.goBack()
            }
        }
        .padding()
        
    }
}

#Preview {
    NetworkError()
}
