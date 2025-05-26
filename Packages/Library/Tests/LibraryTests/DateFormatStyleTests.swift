import Foundation
import Testing
@testable import Library

@Test
func dateLong() throws {
    let components = DateComponents(year: 2025, month: 6, day: 7)
    let date = try #require(Calendar.current.date(from: components))
    let testee = Date.FormatStyle.dateLong
    #expect(testee.format(date) == "7 June 2025")
}
