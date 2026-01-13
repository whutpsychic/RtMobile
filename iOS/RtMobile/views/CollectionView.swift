import SwiftUI
import Combine

// 历史记录管理器
class CollectionManager: ObservableObject {
    private let operationKey = "BrowserCollection"
    private let maxCollectionCount = 100 // 最大保存100条记录
    
    @Published var collections: [CollectedItem] = []
    
    init() {
        loadCollections()
    }
    
    // 从UserDefaults读取历史记录
    private func loadCollections() {
        guard let data = UserDefaults.standard.data(forKey: operationKey) else {
            collections = []
            return
        }
        if let decoded = try? JSONDecoder().decode([CollectedItem].self, from: data) {
            collections = decoded
        } else {
            collections = []
        }
    }
    
    // 保存历史记录到UserDefaults
    private func saveCollection() {
        if let encoded = try? JSONEncoder().encode(collections) {
            UserDefaults.standard.set(encoded, forKey: operationKey)
        }
    }
    
    // 添加新的历史记录
    func addCollection(url: String, title: String) {
        // 检查URL是否已存在，如果存在则更新时间戳
        if let index = collections.firstIndex(where: { $0.url == url }) {
            let item = collections[index]
            // 移除旧项
            collections.remove(at: index)
            // 添加到开头
            collections.insert(item, at: 0)
        } else {
            let newItem = CollectedItem(url: url, title: title)
            collections.insert(newItem, at: 0)
        }
        
        // 限制历史记录数量
        if collections.count > maxCollectionCount {
            collections = Array(collections.prefix(maxCollectionCount))
        }
        
        saveCollection()
    }
    
    // 检查是否存在指定URL的历史记录，如果存在返回索引，否则返回nil
    func indexOfCollection(withURL url: String) -> Int? {
        return collections.firstIndex { $0.url == url }
    }
    
    // 删除特定历史记录
    func removeCollection(at index: Int) {
        if index >= 0 && index < collections.count {
            collections.remove(at: index)
            saveCollection()
        }
    }
    
    // 清除所有历史记录
    func clearAllCollection() {
        collections.removeAll()
        saveCollection()
    }
}

struct CollectionRowView: View {
    let item: CollectedItem
    @State private var isPressed = false
    let onClick: () -> Void
    
    var body: some View {
        HStack {
            // 网站图标占位符
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "star")
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
 
}


