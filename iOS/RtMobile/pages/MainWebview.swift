// 主显示页
import SwiftUI

struct MainWebview: View {
//    @AppStorage("localUrl") var localUrl: String?
    @State private var progress: Double = 0.0
    @State private var isLoading: Bool = false
    @State private var canGoBack = false
    @State private var canGoForward = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 🔵 顶部加载进度条
            if isLoading {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // 背景轨道
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color.gray.opacity(0.3))
                        
                        // 实际进度
                        Rectangle()
                            .frame(width: geometry.size.width * CGFloat(progress), height: 2)
                            .foregroundColor(.blue)
                            .animation(.linear(duration: 0.15), value: progress)
                    }
                }
                .frame(height: 2)
            }
            
            // 🌐 WebView 内容
            MWebView(
                progress: $progress,
                isLoading: $isLoading,
                canGoBack: $canGoBack,
                canGoForward: $canGoForward
            )
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            // 初始化状态
            isLoading = true
            progress = 0.0
        }
    }
}

#Preview {
    MainWebview()
}
