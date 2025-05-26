import Foundation

extension ProcessInfo {
    static var isUITestings: Bool {
        ProcessInfo.processInfo.arguments.contains("UI-Testing")
    }
}
