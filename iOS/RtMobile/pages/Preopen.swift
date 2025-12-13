// 打开App之前的逻辑处理

import SwiftUI

struct Preopen: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("《Preopen》")
        }
        .padding()
    }
}

#Preview {
    Preopen()
}
