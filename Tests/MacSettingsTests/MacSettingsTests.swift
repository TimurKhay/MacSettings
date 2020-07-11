import XCTest
@testable import MacSettings

final class MacSettingsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MacSettings().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
