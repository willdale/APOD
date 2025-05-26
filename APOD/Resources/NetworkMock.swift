import Foundation
import Networking

#if DEBUG
final class NetworkMock: Network {
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        guard let file = Bundle.main.url(forResource: "MockData", withExtension: "json") else {
            throw ReadFromDiskError()
        }
        return (try Data(contentsOf: file), URLResponse())
    }
    
    struct ReadFromDiskError: Error {}
}
#endif
