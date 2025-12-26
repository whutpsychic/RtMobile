// 网络错误页
// 监听网络连接变化，当恢复网络时回退到主前置页

import SwiftUI

struct NavigationError: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Spacer()
            Text("诶呀，你走丢了")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

#Preview {
    NavigationError()
}
