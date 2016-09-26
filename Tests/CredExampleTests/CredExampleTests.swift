import XCTest
@testable import CredExample

class CredExampleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(CredExample().text, "Hello, World!")
    }


    static var allTests : [(String, (CredExampleTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
