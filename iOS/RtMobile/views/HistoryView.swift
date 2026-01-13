import SwiftUI
import Combine

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
    
    // 检查是否存在指定URL的历史记录，如果存在返回索引，否则返回nil
    func indexOfHistory(withURL url: String) -> Int? {
        return history.firstIndex { $0.url == url }
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
