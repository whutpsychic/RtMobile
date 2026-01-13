// 【 推荐网页项目 】
import SwiftUI

struct RecommendItemView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let url: String // 地址
    let title: String // 名称
    let char: String // 字符
    
    let onClick: (() -> Void)?
    
    static let containerWidth: CGFloat = 80 // 组件宽度
    private let containerHeight: CGFloat = 110 // 组件高度
    private let iconSize: CGFloat = 50 // 图标尺寸
    
    // 外壳色系
    private var containerColor: Color {
        return colorScheme == .dark ? Color(hex: "191970"): Color(hex: "AFEEEE")
    }
    
    // 圆色系
    private var circleColor: Color {
        return colorScheme == .dark ? Color(hex: "FFFFFF"): Color.white
    }
    
    // 内方块色系
    private var rectColor: Color {
        return colorScheme == .dark ? Color(hex: "4B0082"): Color(hex: "E1FFFF")
    }
    
    // 内方块首字母色系
    private var charColor: Color {
        return colorScheme == .dark ? Color(hex: "FFFFFF"): Color(hex: "888888")
    }
    
    var body: some View {
        // 内容
        VStack{
            // 上方图标
            ZStack {
                // 圆形背景
                Circle()
                    .fill(circleColor)
                    .frame(width: iconSize, height: iconSize)
                
                // 内部方块
                Rectangle()
                    .fill(rectColor)
                    .frame(width: iconSize*0.7, height: iconSize*0.7)
                    .cornerRadius(5) // 所有角的圆角半径为 20
                
                // 字母
                Text(char)
                    .font(.system(size: iconSize*0.5))
                    .foregroundColor(charColor)
            }
            .frame(maxWidth: .infinity, maxHeight: 80)
            
            // 下方文字
            Text(title)
                .font(.system(size: 14))
                .padding(.bottom, 15)
            
        }
        .frame(width: RecommendItemView.containerWidth, height: containerHeight) // 设置整个组件的尺寸
        .background(containerColor) // 设置背景颜色
        .cornerRadius(10) // 应用圆角
        .onTapGesture {
            if(onClick != nil){
                onClick!()
            }
        }
    }
}
