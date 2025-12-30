import SwiftUI
import Foundation
import Combine

// MARK: - 缓存项结构体
struct CacheItem: Codable {
    let data: String
    let timestamp: Date
    let expirationTime: TimeInterval
    
    var isExpired: Bool {
        return Date().timeIntervalSince(timestamp) > expirationTime
    }
}

// MARK: - 本地缓存管理器
class LocalCacheManager: ObservableObject {
    static let shared = LocalCacheManager()
    
    private let cacheDirectory: URL
    private var inMemoryCache: [String: CacheItem] = [:] // 内存缓存
    
    private init() {
        // 获取文档目录下的缓存文件夹
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.cacheDirectory = documentsPath.appendingPathComponent("Cache")
        
        // 创建缓存目录（如果不存在）
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    // MARK: - 存储数据
    func set(_ value: String, forKey key: String, expirationTime: TimeInterval = 3600*24*365*99) { // 默认99年
        let cacheItem = CacheItem(data: value, timestamp: Date(), expirationTime: expirationTime)
        
        // 先存入内存缓存
        inMemoryCache[key] = cacheItem
        
        // 存储到磁盘
        saveToDisk(cacheItem: cacheItem, forKey: key)
    }
    
    // MARK: - 获取数据
    func get(_ key: String) -> String? {
        // 先检查内存缓存
        if let cachedItem = inMemoryCache[key] {
            if !cachedItem.isExpired {
                return cachedItem.data
            } else {
                // 从内存中移除过期数据
                inMemoryCache.removeValue(forKey: key)
            }
        }
        
        // 从磁盘加载
        if let cachedItem: CacheItem = loadFromDisk(forKey: key) {
            if !cachedItem.isExpired {
                // 重新存入内存缓存
                inMemoryCache[key] = cachedItem
                return cachedItem.data
            } else {
                // 删除过期的磁盘文件
                remove(forKey: key)
            }
        }
        
        return nil
    }
    
    // MARK: - 检查是否存在且未过期
    func exists(_ key: String) -> Bool {
        return get(key) != nil
    }
    
    // MARK: - 删除特定缓存
    func remove(forKey key: String) {
        inMemoryCache.removeValue(forKey: key)
        
        let fileURL = cacheDirectory.appendingPathComponent("$key).cache")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    // MARK: - 清空所有缓存
    func clearAll() {
        inMemoryCache.removeAll()
        
        let fileURLs = try? FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
        fileURLs?.forEach { url in
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    // MARK: - 获取缓存大小
    func getCacheSize() -> Int64 {
        let fileURLs = try? FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
        var size: Int64 = 0
        
        fileURLs?.forEach { url in
            if let values = try? url.resourceValues(forKeys: [.fileSizeKey]) {
                size += Int64(values.fileSize ?? 0)
            }
        }
        
        return size
    }
    
    // MARK: - 私有方法：保存到磁盘
    private func saveToDisk(cacheItem: CacheItem, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent("$key).cache")
        
        do {
            let data = try JSONEncoder().encode(cacheItem)
            try data.write(to: fileURL)
        } catch {
            print("保存缓存失败: $error)")
        }
    }
    
    // MARK: - 私有方法：从磁盘加载
    private func loadFromDisk(forKey key: String) -> CacheItem? {
        let fileURL = cacheDirectory.appendingPathComponent("$key).cache")
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let cacheItem = try JSONDecoder().decode(CacheItem.self, from: data)
            return cacheItem
        } catch {
            print("加载缓存失败: $error)")
            // 如果加载失败，删除损坏的缓存文件
            try? FileManager.default.removeItem(at: fileURL)
            return nil
        }
    }
    
    // MARK: - 清理过期缓存
    func cleanExpiredCache() {
        let fileURLs = try? FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
        fileURLs?.forEach { url in
            let key = url.deletingPathExtension().lastPathComponent
            if let _ = loadFromDisk(forKey: key) {
                // 如果加载后发现已过期，会自动删除
            }
        }
    }
}

// MARK: - SwiftUI 示例视图
struct CacheDemoView: View {
    @StateObject private var cacheManager = LocalCacheManager.shared
    @State private var inputText = ""
    @State private var cachedValue: String?
    @State private var cacheKey = "demo_key"
    @State private var expirationTime: Double = 3600 // 1小时
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("字符串本地缓存演示")
                    .font(.title)
                    .padding()
                
                // 输入框
                VStack {
                    TextField("输入缓存键", text: $cacheKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("输入缓存值", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    HStack {
                        Text("过期时间 (秒):")
                        Spacer()
                        Text("\(Int(expirationTime))")
                    }
                    .padding(.horizontal)
                    
                    Slider(value: $expirationTime, in: 60...3600, step: 60)
                        .padding(.horizontal)
                }
                
                // 操作按钮
                HStack {
                    Button("保存") {
                        cacheManager.set(inputText, forKey: cacheKey, expirationTime: expirationTime)
                        inputText = ""
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("读取") {
                        cachedValue = cacheManager.get(cacheKey)
                    }
                    .buttonStyle(.bordered)
                }
                
                // 显示缓存值
                if let value = cachedValue {
                    VStack {
                        Text("缓存值:")
                            .font(.headline)
                        Text(value)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding()
                }
                
                // 缓存信息
                VStack(alignment: .leading) {
                    Text("缓存信息:")
                        .font(.headline)
                    
                    Text("存在: $cacheManager.exists(cacheKey))")
                    Text("大小: $formatFileSize(cacheManager.getCacheSize()))")
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func formatFileSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}

// MARK: - 预览
struct CacheDemoView_Previews: PreviewProvider {
    static var previews: some View {
        CacheDemoView()
    }
}



