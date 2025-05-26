import Foundation
import Library

extension NetworkManager {
    public func fetchAPOD(for date: Date) async throws -> APODResponse {
        let url = URL(string: "https://api.nasa.gov/planetary/apod")?
            .appending(queryItems: [
                URLQueryItem(name: "api_key", value: Self.apiKey),
                URLQueryItem(name: "date", value: DateFormatter.year.string(from: date)),
            ])
        
        guard let url else {
            throw NetowrkingError.couldNotCreateURLRequest
        }
        return try await self.fetch(APODResponse.self, url: url)
    }
}
