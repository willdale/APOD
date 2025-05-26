import Foundation
import Networking

final class NetworkMock: Network {
    var dataImpl: (URL, (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) = { _, _ in throw Unimplemented() }
    
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        try await dataImpl(url, delegate)
    }
    
    struct Unimplemented: Error {}
}
