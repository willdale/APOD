import Foundation
import Testing
@testable import Library

@Test
func year() throws {
    let testee = DateFormatter.year
    #expect(testee.dateFormat == "yyyy-MM-dd")
}
