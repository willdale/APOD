import XCTest

final class APODUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    @MainActor
    func test_homeScreen() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UI-Testing")
        app.launch()
        XCTAssertEqual(app.staticTexts["title"].label, "Alpha Centauri: The Closest Star System")
        XCTAssertTrue(app.staticTexts["explanation"].label.hasPrefix("The closest star system to the Sun is the Alpha Centauri system."))
        XCTAssertEqual(app.staticTexts["date"].label, "1 January 2025")
        XCTAssertEqual(app.staticTexts["copyright"].label, "Copyright: Telescope Live, Heaven's Mirror Observatory; Processing: Chris Cantrell")
    }
}
