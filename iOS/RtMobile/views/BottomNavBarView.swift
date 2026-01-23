import SwiftUI

// 底部导航栏组件
struct BottomNavigationBar: View {
    let visible: Bool // menu是否可见
    let loading: Bool // 正在加载
    let progress: Double // 当前进度值
    let canGoBack: Bool // 后退是否可用
    let canGoForward: Bool // 前进是否可用
    
    let onPressBack: () -> Void // 点击后退
    let onPressForward: () -> Void // 点击前进
    let onPressHome: () -> Void // 点击首页
    let onPressRefresh: () -> Void // 点击刷新
    let onPressMore: () -> Void // 点击更多
    
    let onExpand: () -> Void // 点击展开
    
    var body: some View {
        VStack{
            // 进度条
            if loading{
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(maxWidth: .infinity) // 确保宽度占满
                    .offset(y: visible ? 8 : 10) // 隐藏时向下偏移
                    .animation(.easeInOut(duration: 0.2), value: visible)
            }
            
            HStack(spacing: 40){
                if(visible){
                    BottomNavItem(icon: "chevron.left", disabled: !canGoBack, action: onPressBack)
                    BottomNavItem(icon: "chevron.right", disabled: !canGoForward, action: onPressForward)
                    BottomNavItem(icon: "house", action: onPressHome)
                    BottomNavItem(icon: "arrow.clockwise", disabled: loading, action: onPressRefresh)
                    BottomNavItem(icon: "ellipsis", action: onPressMore)
                }else{
                    ZStack{
                        //底部文字
                        Text("Rtmobile")
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity)
                        // 展开按键
                        HStack{
                            Spacer()
                            BottomNavItem(icon: "ellipsis", action: onExpand)
                                .padding(.trailing, 40)
                        }
                    }
                }
            }
            .frame(height: visible ? 50 : 25)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color(.separator)),
                alignment: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
            
        }
        .offset(y: visible ? 0 : 0) // 隐藏时向下偏移
        .animation(.easeInOut(duration: 0.2), value: visible)
    }
}

// 导航项按钮
struct BottomNavItem: View {
    @Environment(\.colorScheme) var colorScheme
    
    let icon: String
    let disabled: Bool?
    let action: () -> Void
    
    init(icon: String, disabled: Bool? = false, action: @escaping () -> Void){
        self.icon = icon
        self.disabled = disabled
        self.action = action
    }
    
    private var color: Color{
        if(colorScheme == .dark){
            return (disabled ?? false) ? Color(hex: "233333") : .primary
        }
        else{
            return (disabled ?? false) ? Color(hex: "DDDDDD") : .primary
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            .frame(width: 40)
        }
        .disabled(disabled ?? false)
    }
}
