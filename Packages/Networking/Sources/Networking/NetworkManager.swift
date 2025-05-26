import SwiftUI

public final class NetworkManager {
    let session: any Network
    
    public init(session: any Network = URLSession.shared) {
        self.session = session
    }
    
    public func fetch<T>(_ type: T.Type, url: URL) async throws -> T where T: Decodable {
        let (data, _) = try await session.data(from: url, delegate: nil)
        return try JSONDecoder.default.decode(T.self, from: data)
    }
    
    static let apiKey = "RNJGEwhSmwqQiyoq4rVAbsQRJDqYJx9iSNCafCJa" // Should use White-Box Cryptography or other method of obfuscation
}

public extension EnvironmentValues {
    @Entry var networkManager = NetworkManager()
}
