import Foundation
@testable import Networking
import Testing

struct NetworkInterfaceTests {
    @Test
    func fetchAPOD_urlIsConstructedCorrectly() async throws {
        let session = NetworkMock()
        let manager = NetworkManager(session: session)
        
        let components = DateComponents(year: 2025, month: 6, day: 7)
        let date = try #require(Calendar.current.date(from: components))
        session.dataImpl = { url, _ in
            #expect(url.absoluteString == "https://api.nasa.gov/planetary/apod?api_key=RNJGEwhSmwqQiyoq4rVAbsQRJDqYJx9iSNCafCJa&date=2025-06-07")
            throw NetowrkingError.couldNotCreateURLRequest
        }
        
        await #expect(throws: NetowrkingError.couldNotCreateURLRequest) {
            try await manager.fetchAPOD(for: date)
        }
    }
    
    @Test
    func fetchAPOD_reponseIsDecodedCorrectly() async throws {
        let session = NetworkMock()
        let manager = NetworkManager(session: session)
        
        let components = DateComponents(year: 2025, month: 1, day: 1)
        let date = try #require(Calendar.current.date(from: components))
        session.dataImpl = { url, _ in
            let file =  try #require(Bundle.module.url(forResource: "MockData", withExtension: "json"))
            return (try Data(contentsOf: file), URLResponse())
        }
        
        let testee = try await manager.fetchAPOD(for: date)
        #expect(testee.title == "Alpha Centauri: The Closest Star System")
        #expect(testee.explanation == "The closest star system to the Sun is the Alpha Centauri system. O...")
        #expect(testee.date == date)
        #expect(testee.url.absoluteString == "https://apod.nasa.gov/apod/image/2501/AlphaCen_Cantrell_960.jpg")
        #expect(testee.hdurl?.absoluteString == "https://apod.nasa.gov/apod/image/2501/AlphaCen_Cantrell_3429.jpg")
        #expect(testee.mediaType == "image")
        #expect(testee.serviceVersion == "v1")
        #expect(testee.copyright == "Telescope Live, Heaven's Mirror Observatory; Processing: Chris Cantrell")
        
    }
}
