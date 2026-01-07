import SwiftUI

struct CircularProgressView: View {
    let progress: Double // 0.0 ~ 1.0
    let lineWidth: CGFloat = 5
    let color: Color = .blue
    let size: CGFloat = 130
    
    var body: some View {
        ZStack {
            // 背景圆环（未完成部分）
            Circle()
                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            
            // 进度圆环（已完成部分）
            Circle()
                .trim(from: 0, to: min(progress, 1)) // 限制最大为1
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90)) // 从顶部开始（默认从右侧开始）
                .animation(.easeOut(duration: 0.5), value: progress)
        }
        .frame(width: size, height: size)
    }
}
