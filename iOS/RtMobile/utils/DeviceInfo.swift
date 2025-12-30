import Foundation
import UIKit

// MARK: - 设备信息工具类
class DeviceInfo {
    
    // MARK: - 设备名称
    static var deviceName: String {
        UIDevice.current.name
    }
    
    // MARK: - 系统名称 (iOS)
    static var systemName: String {
        UIDevice.current.systemName
    }
    
    // MARK: - iOS 版本号
    static var systemVersion: String {
        UIDevice.current.systemVersion
    }
    
    // MARK: - 型号名称 (如 iPhone14,5)
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier.isEmpty ? "Unknown" : identifier
    }
    
    // MARK: - 显示型号 (如 iPhone 13 mini)
    static var modelDisplayName: String {
        let modelIdentifier = modelName
        // 常见型号映射表
        let modelMap: [String: String] = [
            // iPhone
            "iPhone1,1": "iPhone",
            "iPhone1,2": "iPhone 3G",
            "iPhone2,1": "iPhone 3GS",
            "iPhone3,1": "iPhone 4",
            "iPhone3,2": "iPhone 4",
            "iPhone3,3": "iPhone 4",
            "iPhone4,1": "iPhone 4s",
            "iPhone5,1": "iPhone 5",
            "iPhone5,2": "iPhone 5",
            "iPhone5,3": "iPhone 5c",
            "iPhone5,4": "iPhone 5c",
            "iPhone6,1": "iPhone 5s",
            "iPhone6,2": "iPhone 5s",
            "iPhone7,1": "iPhone 6 Plus",
            "iPhone7,2": "iPhone 6",
            "iPhone8,1": "iPhone 6s",
            "iPhone8,2": "iPhone 6s Plus",
            "iPhone8,4": "iPhone SE",
            "iPhone9,1": "iPhone 7",
            "iPhone9,3": "iPhone 7",
            "iPhone9,2": "iPhone 7 Plus",
            "iPhone9,4": "iPhone 7 Plus",
            "iPhone10,1": "iPhone 8",
            "iPhone10,4": "iPhone 8",
            "iPhone10,2": "iPhone 8 Plus",
            "iPhone10,5": "iPhone 8 Plus",
            "iPhone10,3": "iPhone X",
            "iPhone10,6": "iPhone X",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max",
            "iPhone11,6": "iPhone XS Max",
            "iPhone11,8": "iPhone XR",
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            "iPhone12,8": "iPhone SE (2nd generation)",
            "iPhone13,1": "iPhone 12 mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone14,4": "iPhone 13 mini",
            "iPhone14,5": "iPhone 13",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,6": "iPhone SE (3rd generation)",
            "iPhone14,7": "iPhone 14",
            "iPhone14,8": "iPhone 14 Plus",
            "iPhone15,2": "iPhone 14 Pro",
            "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone15,4": "iPhone 15",
            "iPhone15,5": "iPhone 15 Plus",
            "iPhone16,1": "iPhone 15 Pro",
            "iPhone16,2": "iPhone 15 Pro Max",
            
            // iPad
            "iPad1,1": "iPad",
            "iPad1,2": "iPad 3G",
            "iPad2,1": "iPad 2",
            "iPad2,2": "iPad 2",
            "iPad2,3": "iPad 2",
            "iPad2,4": "iPad 2",
            "iPad2,5": "iPad mini",
            "iPad2,6": "iPad mini",
            "iPad2,7": "iPad mini",
            "iPad3,1": "iPad (3rd generation)",
            "iPad3,2": "iPad (3rd generation)",
            "iPad3,3": "iPad (3rd generation)",
            "iPad3,4": "iPad (4th generation)",
            "iPad3,5": "iPad (4th generation)",
            "iPad3,6": "iPad (4th generation)",
            "iPad4,1": "iPad Air",
            "iPad4,2": "iPad Air",
            "iPad4,3": "iPad Air",
            "iPad4,4": "iPad mini 2",
            "iPad4,5": "iPad mini 2",
            "iPad4,6": "iPad mini 2",
            "iPad4,7": "iPad mini 3",
            "iPad4,8": "iPad mini 3",
            "iPad4,9": "iPad mini 3",
            "iPad5,1": "iPad mini 4",
            "iPad5,2": "iPad mini 4",
            "iPad5,3": "iPad Air 2",
            "iPad5,4": "iPad Air 2",
            "iPad6,3": "iPad Pro (9.7-inch)",
            "iPad6,4": "iPad Pro (9.7-inch)",
            "iPad6,7": "iPad Pro (12.9-inch)",
            "iPad6,8": "iPad Pro (12.9-inch)",
            "iPad6,11": "iPad (5th generation)",
            "iPad6,12": "iPad (5th generation)",
            "iPad7,1": "iPad Pro (12.9-inch) (2nd generation)",
            "iPad7,2": "iPad Pro (12.9-inch) (2nd generation)",
            "iPad7,3": "iPad Pro (10.5-inch)",
            "iPad7,4": "iPad Pro (10.5-inch)",
            "iPad7,5": "iPad (6th generation)",
            "iPad7,6": "iPad (6th generation)",
            "iPad7,11": "iPad (7th generation)",
            "iPad7,12": "iPad (7th generation)",
            "iPad8,1": "iPad Pro (11-inch)",
            "iPad8,2": "iPad Pro (11-inch)",
            "iPad8,3": "iPad Pro (11-inch)",
            "iPad8,4": "iPad Pro (11-inch)",
            "iPad8,5": "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,6": "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,7": "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,8": "iPad Pro (12.9-inch) (3rd generation)",
            "iPad8,9": "iPad Pro (11-inch) (2nd generation)",
            "iPad8,10": "iPad Pro (11-inch) (2nd generation)",
            "iPad8,11": "iPad Pro (12.9-inch) (4th generation)",
            "iPad8,12": "iPad Pro (12.9-inch) (4th generation)",
            "iPad11,1": "iPad mini (5th generation)",
            "iPad11,2": "iPad mini (5th generation)",
            "iPad11,3": "iPad Air (3rd generation)",
            "iPad11,4": "iPad Air (3rd generation)",
            "iPad11,6": "iPad (8th generation)",
            "iPad11,7": "iPad (8th generation)",
            "iPad12,1": "iPad (9th generation)",
            "iPad12,2": "iPad (9th generation)",
            "iPad13,1": "iPad Air (4th generation)",
            "iPad13,2": "iPad Air (4th generation)",
            "iPad13,4": "iPad Pro (11-inch) (3rd generation)",
            "iPad13,5": "iPad Pro (11-inch) (3rd generation)",
            "iPad13,6": "iPad Pro (11-inch) (3rd generation)",
            "iPad13,7": "iPad Pro (11-inch) (3rd generation)",
            "iPad13,8": "iPad Pro (12.9-inch) (5th generation)",
            "iPad13,9": "iPad Pro (12.9-inch) (5th generation)",
            "iPad13,10": "iPad Pro (12.9-inch) (5th generation)",
            "iPad13,11": "iPad Pro (12.9-inch) (5th generation)",
            "iPad14,1": "iPad mini (6th generation)",
            "iPad14,2": "iPad mini (6th generation)",
            "iPad14,3-A": "iPad Pro (11-inch) (4th generation)",
            "iPad14,3-B": "iPad Pro (11-inch) (4th generation)",
            "iPad14,4-A": "iPad Pro (11-inch) (4th generation)",
            "iPad14,4-B": "iPad Pro (11-inch) (4th generation)",
            "iPad14,5-A": "iPad Pro (12.9-inch) (6th generation)",
            "iPad14,5-B": "iPad Pro (12.9-inch) (6th generation)",
            "iPad14,6-A": "iPad Pro (12.9-inch) (6th generation)",
            "iPad14,6-B": "iPad Pro (12.9-inch) (6th generation)",
            
            // iPod
            "iPod1,1": "iPod touch",
            "iPod2,1": "iPod touch (2nd generation)",
            "iPod3,1": "iPod touch (3rd generation)",
            "iPod4,1": "iPod touch (4th generation)",
            "iPod5,1": "iPod touch (5th generation)",
            "iPod7,1": "iPod touch (6th generation)",
            "iPod9,1": "iPod touch (7th generation)"
        ]
        
        return modelMap[modelIdentifier] ?? modelIdentifier
    }
    
    // MARK: - 屏幕尺寸
    static var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
    
    // MARK: - 屏幕宽度
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    // MARK: - 屏幕高度
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    // MARK: - 屏幕缩放
    static var screenScale: CGFloat {
        UIScreen.main.scale
    }
    
    // MARK: - 当前屏幕方向
    static var currentInterfaceOrientation: String {
        if #available(iOS 15, *) {
            // iOS 15+ 推荐方式
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows where window.isKeyWindow {
                        let orientation = window.windowScene?.interfaceOrientation
                        return orientationString(from: orientation)
                    }
                }
            }
            // Fallback to first window
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let orientation = window.windowScene?.interfaceOrientation
                return orientationString(from: orientation)
            }
        } else {
            // iOS 14 及以下
            let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
            return orientationString(from: orientation)
        }
        return "Unknown"
    }
    
    private static func orientationString(from orientation: UIInterfaceOrientation?) -> String {
        switch orientation {
        case .portrait:
            return "Portrait"
        case .portraitUpsideDown:
            return "Portrait Upside Down"
        case .landscapeLeft:
            return "Landscape Left"
        case .landscapeRight:
            return "Landscape Right"
        default:
            return "Unknown"
        }
    }
    
    // MARK: - 获取设备唯一标识符（同一开发商应用共享）
    static var vendorIdentifier: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    // MARK: - 打印所有信息
    static func printAll() {
        print("=== Device Information ===")
        print("设备名称: \(deviceName)")
        print("系统名称: \(systemName)")
        print("系统版本: \(systemVersion)")
        print("型号名称: \(modelName)")
        print("显示型号: \(modelDisplayName)")
        print("屏幕尺寸: \(screenWidth) x \(screenHeight)")
        print("屏幕缩放: \(screenScale)x")
        print("当前方向: \(currentInterfaceOrientation)")
        print("=========================")
    }
    
    static func getAllInfo() -> String {
        let deviceInfo = [
            "deviceId": DeviceInfo.vendorIdentifier as Any,
            "deviceName": DeviceInfo.deviceName,
            "systemName": DeviceInfo.systemName,
            "systemVersion": DeviceInfo.systemVersion,
            "modelDisplayName": DeviceInfo.modelDisplayName,
            "screenWidth": DeviceInfo.screenWidth,
            "screenHeight": DeviceInfo.screenHeight,
            "orientation": DeviceInfo.currentInterfaceOrientation,
        ] as [String : Any]
        // 将数据转换为 JSON 字符串
        guard let jsonData = try? JSONSerialization.data(withJSONObject: deviceInfo, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("无法序列化设备信息为 JSON")
            return ""
        }
        return jsonString
    }
}
