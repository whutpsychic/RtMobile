// 主显示页
import SwiftUI
import Combine

// 任务管理器 - 专门用于管理异步任务
class TaskManager: ObservableObject {
    private var tasks: [UUID: Task<Void, Never>] = [:]
    
    // 创建一个带ID的任务
    func createTask(id: UUID = UUID(), operation: @escaping () async -> Void) {
        // 取消相同ID的现有任务
        cancelTask(id: id)
        
        let task = Task {
            await operation()
        }
        
        tasks[id] = task
    }
    
    // 创建一个延迟任务
    func createDelayTask(id: UUID = UUID(), delayNanoseconds: UInt64, operation: @escaping () -> Void) {
        // 取消相同ID的现有任务
        cancelTask(id: id)
        
        let task = Task {
            do {
                try await Task.sleep(nanoseconds: delayNanoseconds)
                // 检查任务是否被取消
                try Task.checkCancellation()
                await MainActor.run {
                    operation()
                }
            } catch {
                // 任务被取消或其他错误
                print("任务 \(id) 被取消或出错: \(error)")
            }
        }
        
        tasks[id] = task
    }
    
    // 取消特定ID的任务
    func cancelTask(id: UUID) {
        tasks[id]?.cancel()
        tasks.removeValue(forKey: id)
    }
    
    // 取消所有任务
    func cancelAllTasks() {
        for task in tasks.values {
            task.cancel()
        }
        tasks.removeAll()
    }
    
    // 检查任务是否存在
    func hasTask(id: UUID) -> Bool {
        return tasks[id] != nil
    }
    
    // 获取任务数量
    func taskCount() -> Int {
        return tasks.count
    }
}
