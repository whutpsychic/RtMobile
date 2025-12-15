//
//  RtMobileApp.swift
//  RtMobile
//
//  Created by zbc0012 on 2025/12/13.
//
//@AppStorage("localUrl") var localUrl:String = ""  // 本地存储的url

import SwiftUI

@main
struct RtMobileApp: App {
    @State public var path = NavigationPath()
    @StateObject private var networkMonitor = NetworkMonitor.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path){
                // 《前置页》
                Preopen(onShouldNavigate: { route in
                    if let route = route {
                        path.append(route)
                    }
                })
                .environmentObject(networkMonitor)
                .navigationDestination(for: String.self) { route in
                    // 根据 route 类型决定目标页面
                    // 《网络错误页》
                    if route == "noNetwork" {
                        NetworkError{
                            // 网络恢复，返回上一页
                            DispatchQueue.main.async {
                                print(" - - - - - - -")
                                if !path.isEmpty {
                                    path.removeLast()
                                }
                            }
                        }.navigationBarHidden(true)  // 👈 隐藏整个导航栏
                    }
                }
            }
        }
    }
}
