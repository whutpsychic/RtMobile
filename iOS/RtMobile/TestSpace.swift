import SwiftUI

struct TestPage1: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Spacer()
            Text("TestPage1")
            Spacer()
            // 主页面内容
            Button("前往 TestPage2") {
                router.navigate(to: "p2")
            }
            Spacer()
            Button("前往 TestPage3") {
                router.navigate(to: "p3")
            }
            Spacer()
        }
        .navigationDestination(for: String.self) { route in
            switch route {
            case "p2":
                TestPage2().environmentObject(router)
            case "p3":
                TestPage3().environmentObject(router)
            default:
                Text("未知页面")
            }
        }
    }
}

struct TestPage2: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Spacer()
            Text("TestPage2")
            Spacer()
            // 主页面内容
            Button("前往 TestPage1") {
                router.navigate(to: "p1")
            }
            Spacer()
            Button("前往 TestPage3") {
                router.navigate(to: "p3")
            }
            Spacer()
        }
        .navigationDestination(for: String.self) { route in
            switch route {
            case "p1":
                TestPage1().environmentObject(router)
            case "p3":
                TestPage3().environmentObject(router)
            default:
                Text("未知页面")
            }
        }
    }
}

struct TestPage3: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Spacer()
            Text("TestPage3")
            // 主页面内容
            Spacer()
            Button("前往 TestPage1") {
                router.navigate(to: "p1")
            }
            Spacer()
            Button("前往 TestPage2") {
                router.navigate(to: "p2")
            }
            Spacer()
        }
        .navigationDestination(for: String.self) { route in
            switch route {
            case "p1":
                TestPage1().environmentObject(router)
            case "p2":
                TestPage2().environmentObject(router)
            default:
                Text("未知页面")
            }
        }
    }
}

