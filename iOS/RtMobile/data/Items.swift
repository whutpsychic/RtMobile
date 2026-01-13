// 首页顶部的推荐网页栏目
import SwiftUI
//import Combine

// 历史记录项的数据结构
struct HistoryItem: Codable, Identifiable {
    var id = UUID()
    let url: String
    let title: String
    var timestamp: Date
}

// 收藏网址数据结构
struct CollectedItem: Codable, Identifiable {
    var id = UUID()
    let url: String
    let title: String
}

// 推荐网址数据结构
struct RecommendItem: Codable, Identifiable {
    var id = UUID()
    let url: String
    let title: String
    var firstChar: String
}

// 推荐网址列表
let recommendUrlList: [RecommendItem] = [
    RecommendItem(url: "http://www.rtlink.com.cn/", title: "瑞太", firstChar: "R"),
    RecommendItem(url: "https://www.baidu.com/", title: "百度", firstChar: "B"),
    RecommendItem(url: "https://www.tencent.com/", title: "腾讯", firstChar: "T"),
    RecommendItem(url: "https://www.sina.com/", title: "新浪", firstChar: "S"),
]
