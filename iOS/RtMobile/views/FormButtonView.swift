import SwiftUI

// 底部导航栏组件
struct FormButton: View {
    let label: String
    let icon: String?
    let action: () -> Void // 点击事件
    
    init(_ label: String, _ icon: String? = "chevron.right", action: @escaping () -> Void){
        self.label = label
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action)
        {
            HStack {
                Text(label)
                Spacer()
                Image(systemName: icon!)
                    .resizable() // 使图片可调整大小
                    .aspectRatio(contentMode: .fit) // 保持原始宽高比
                    .frame(width: 14, height: 14) // 设置你想要的宽度和高度
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

