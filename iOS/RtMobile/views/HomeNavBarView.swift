import SwiftUI

// 底部导航栏组件
struct HomeNavBarView: View {
    
    let viewCollection: () -> Void       // 点击收藏
    let viewHistory: () -> Void       // 点击历史
    
    private let screenWidth = UIScreen.main.bounds.width
    // 计算底部条项目间距（也作为计算属性）
    private var menuSpliter: CGFloat {
        (screenWidth - 40 * 4) / 5
    }
    
    var body: some View {
        HStack(spacing: menuSpliter) {
            HomeNavItem(icon: "star"){
                viewCollection()
            }
            HomeNavItem(icon: "clock"){
                viewHistory()
            }
        }
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground)) // 使用系统背景色
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .top
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

// 导航项按钮
struct HomeNavItem: View {
    let icon: String
    let action: () -> Void       // 点击回调
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor( Color.blue )
            }
            .frame(width: 60)
            .padding(.top, 20)
        }
    }
}
