import Networking
import SwiftUI

@main
struct APODApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.networkManager, networkManager)
        }
    }
    
    var networkManager: NetworkManager {
        NetworkManager(session: ProcessInfo.isUITestings ? NetworkMock() : URLSession.shared)
    }
}
