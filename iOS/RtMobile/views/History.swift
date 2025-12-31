import SwiftUI
import Combine

// 定义历史记录项的结构
struct HistoryItem: Codable, Identifiable {
    var id = UUID()
    let url: String
    let title: String
    var timestamp: Date
}

// 历史记录管理器
class HistoryManager: ObservableObject {
    private let historyKey = "BrowserHistory"
    private let maxHistoryCount = 100 // 最大保存100条记录
    
    @Published var history: [HistoryItem] = []
    
    init() {
        loadHistory()
    }
    
    // 从UserDefaults读取历史记录
    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            history = []
            return
        }
        if let decoded = try? JSONDecoder().decode([HistoryItem].self, from: data) {
            history = decoded
        } else {
            history = []
        }
    }
    
    // 保存历史记录到UserDefaults
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    // 添加新的历史记录
    func addHistory(url: String, title: String) {
        // 检查URL是否已存在，如果存在则更新时间戳
        if let index = history.firstIndex(where: { $0.url == url }) {
            var item = history[index]
            item.timestamp = Date()
            // 移除旧项
            history.remove(at: index)
            // 添加到开头
            history.insert(item, at: 0)
        } else {
            let newItem = HistoryItem(url: url, title: title, timestamp: Date())
            history.insert(newItem, at: 0)
        }
        
        // 限制历史记录数量
        if history.count > maxHistoryCount {
            history = Array(history.prefix(maxHistoryCount))
        }
        
        saveHistory()
    }
    
    // 删除特定历史记录
    func removeHistory(at index: Int) {
        if index >= 0 && index < history.count {
            history.remove(at: index)
            saveHistory()
        }
    }
    
    // 清除所有历史记录
    func clearAllHistory() {
        history.removeAll()
        saveHistory()
    }
}

struct HistoryRowView: View {
    let item: HistoryItem
    @State private var isPressed = false
    let onClick: () -> Void
    
    var body: some View {
        HStack {
            // 网站图标占位符
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "globe")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(item.url)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(formatDate(item.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle()) // 确保整个HStack区域可点击
        .onTapGesture {
            // 在这里添加点击事件处理逻辑
            onClick()
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct HistoryListView: View {
    @EnvironmentObject var historyManager: HistoryManager // 路由
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    let cancel: () -> Void
    let onConfirm: (_ title: String, _ url: String) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                if historyManager.history.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("暂无历史记录")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("访问网页后历史记录将显示在此处")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(Array(historyManager.history.enumerated()), id: \.element.id) { index, item in
                            HistoryRowView(item: item){
                                print(item.title)
                                print(item.url)
                                onConfirm(item.title, item.url)
                            }
                        }
                    }
                }
            }
            .navigationTitle("历史记录")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        cancel()
                    }
                    .foregroundColor(.blue)
                }
                
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
                    historyManager.clearAllHistory()
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
}
