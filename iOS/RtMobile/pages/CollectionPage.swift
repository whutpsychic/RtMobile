// 历史页面
import SwiftUI

struct CollectionPage: View {
    @EnvironmentObject var collectionManager: CollectionManager // 管理器
    @Environment(\.dismiss) private var dismiss // 获取 dismiss 环境变量
    
    let onConfirm: (_ item: CollectedItem) -> Void // 点击条目
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            if collectionManager.collections.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("暂无收藏地址")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("访问网页后收藏内容将显示在此处")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(Array(collectionManager.collections.enumerated()), id: \.element.id) { index, item in
                        CollectionRowView(item: item){
                            onConfirm(item)
                            dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle("我的收藏")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(){
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("清除") {
                    showingAlert = true
                }
                .foregroundColor(.red)
            }
        }
        .alert("确认清除", isPresented: $showingAlert) {
            Button("取消", role: .cancel) { }
            Button("清除", role: .destructive) {
                collectionManager.clearAllCollection()
            }
        } message: {
            Text("确定要清除所有历史记录吗？此操作无法撤销。")
        }
        
        // 示例：添加一些测试数据
        .onAppear {
            //                if historyManager.history.isEmpty {
            //                    historyManager.addHistory(url: "https://www.apple.com", title: "Apple")
            //                    historyManager.addHistory(url: "https://www.swift.org", title: "Swift Programming Language")
            //                    historyManager.addHistory(url: "https://developer.apple.com", title: "Apple Developer")
            //                }
        }
        
    }
}
