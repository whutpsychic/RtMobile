// 网络错误页

import SwiftUI

struct NetworkError: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("《NetworkError》")
        }
        .padding()
    }
}

#Preview {
    NetworkError()
}
