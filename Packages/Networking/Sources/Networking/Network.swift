import Foundation

public protocol Network {
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: Network { /* Already conforms to protocol */ }
