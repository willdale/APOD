import Networking
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var viewState: ViewState = .loading
    @Published var date: Date = .now
    @Published var shouldShouldDateSelection: Bool = false
    private weak var networkManager: NetworkManager?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func allowableDateRange(_ currentDate: Date = .now) -> ClosedRange<Date> {
        let components = DateComponents(year: 1995, month: 6, day: 16)
        let startDate = Calendar.current.date(from: components) ?? .distantPast
        return startDate...currentDate
    }
    
    func fetchAPOD() async {
        do {
            viewState = .loading
            guard let networkManager else {
                print("Error: No Network Manager")
                throw NetowrkingError.noNetworkingManager
            }
            let apod = try await networkManager.fetchAPOD(for: date).convert()
            viewState = .ideal(apod)
        } catch where viewState.isIdeal {
            print("Error: Failed to fetch APOD due to error: \(error.localizedDescription) | Keeping previous state")
        } catch {
            print("Error: Failed to fetch APOD due to error: \(error.localizedDescription)")
            viewState = .error
        }
    }
    
    // MARK: Models
    
    enum ViewState: Equatable {
        case loading
        case ideal(APOD)
        case error
        
        var isIdeal: Bool {
            switch self {
            case .ideal: true
            default: false
            }
        }
    }
    
    struct APOD: Equatable {
        let title: String
        let explanation: String
        let date: Date
        let mediaURL: URL
        let copyright: String?
        let mediaType: MediaType
        
        init(_ response: APODResponse) {
            self.title = response.title
            self.explanation = response.explanation
            self.date = response.date
            self.mediaURL = response.url
            self.copyright = response.copyright?.replacingOccurrences(of: "\n", with: "")
            self.mediaType = MediaType(rawValue: response.mediaType) ?? .image
        }
        
        enum MediaType: String {
            case image
            case video
        }
    }
}

extension APODResponse {
    func convert() -> HomeViewModel.APOD {
        return HomeViewModel.APOD(self)
    }
}
