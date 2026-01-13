// NetworkMonitor.swift
// 网络连接状态监听器
import Network
import Combine
import SwiftUI

class NetworkMonitor: ObservableObject {
    public static let shared = NetworkMonitor() // 单例，全局唯一
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor", qos: .utility)
    
    @Published var isConnected = false
    @Published var connectionType: String = "Unknown"
    
    private init() {
        // 初始状态
        updateStatus(for: monitor.currentPath)
        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.updateStatus(for: path)
        }
        
        monitor.start(queue: queue)
    }
    
    private func updateStatus(for path: Network.NWPath) {
        let connected = path.status == .satisfied
        var type = "Unknown"
        
        switch path.availableInterfaces.first?.type {
        case .wifi:
            type = "Wifi"
        case .cellular:
            type = "Cellular"
        case .wiredEthernet:
            type = "Ethernet"
        case .loopback:
            type = "Loopback"
        default:
            type = connected ? "Connected" : "Disconnected"
        }
        
        // 确保在主线程更新 @Published（虽然 SwiftUI 通常会处理，但显式更安全）
        DispatchQueue.main.async {
            self.isConnected = connected
            self.connectionType = type
        }
    }
    
    deinit {
        monitor.cancel()
    }
}
