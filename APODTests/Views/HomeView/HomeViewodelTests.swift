@testable import APOD
import Networking
import XCTest

@MainActor
final class HomeViewModelTests: XCTestCase {
    func test_allowableDateRange() throws {
        let components = DateComponents(year: 2025, month: 6, day: 7)
        let endDate = try XCTUnwrap(Calendar.current.date(from: components))
        
        let networManager = NetworkManager(session: NetworkMock())
        let testee = HomeViewModel(networkManager: networManager)
        let expected = testee.allowableDateRange(endDate)
        
        let startDate = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 16)))
        XCTAssertEqual(expected, startDate...endDate)
    }
    
    func test_fetchAPOD_setsViewState_andConvertsDataCorrectly() async throws {
        let session = NetworkMock()
        let networManager = NetworkManager(session: session)
        let testee = HomeViewModel(networkManager: networManager)
        
        session.dataImpl = { _, _ in
            let file = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "MockData", withExtension: "json"))
            return (try Data(contentsOf: file), URLResponse())
        }
        
        XCTAssertEqual(testee.viewState, .loading)
        await testee.fetchAPOD()
        
        guard case let .ideal(apod) = testee.viewState else {
            XCTFail("Should be view state of ideal")
            return
        }
        let date = try XCTUnwrap(Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 1)))
        
        XCTAssertEqual(apod.title, "Alpha Centauri: The Closest Star System")
        XCTAssertEqual(apod.explanation, "The closest star system to the Sun is the Alpha Centauri system. O...")
        XCTAssertEqual(apod.date, date)
        XCTAssertEqual(apod.mediaURL.absoluteString, "https://apod.nasa.gov/apod/image/2501/AlphaCen_Cantrell_960.jpg")
        XCTAssertEqual(apod.copyright, "Telescope Live, Heaven\'s Mirror Observatory; Processing: Chris Cantrell")
        XCTAssertEqual(apod.mediaType, .image)

    }
}

extension HomeViewModelTests {
    private final class NetworkMock: Network {
        var dataImpl: (URL, (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) = { _, _ in throw Unimplemented() }
        
        func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
            try await dataImpl(url, delegate)
        }
        
        struct Unimplemented: Error {}
    }
}
