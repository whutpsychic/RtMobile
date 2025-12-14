// 打开App之前的逻辑处理

import SwiftUI

struct Preopen: View {
    @State private var showUrlPage = false // 控制是否显示sheet
    
    public func goto(_ url:String){
        // TODO 前往该网页
        print("goto func")
    }
    
    var body: some View {
        ZStack {
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
        }
    }
}

#Preview {
    Preopen()
}
