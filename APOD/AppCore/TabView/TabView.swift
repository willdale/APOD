import Networking
import SwiftUI

struct ContentView: View {
    @Environment(\.networkManager) private var networkManager
    @State private var tabSelection: TabSelection = .home
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView(networkManager: networkManager)
                .tabItem {
                    Label("Home", systemImage: tabSelection.isHome ? "house.fill" : "house")
                }
                .tag(TabSelection.home)
        }
        .tabViewStyle(.automatic)
    }
    
    enum TabSelection: Hashable {
        case home
        
        var isHome: Bool {
            switch self {
            case .home: true
            }
        }
    }
}

#Preview {
    ContentView()
}
