import Cocoa
import XCTest

class ProcessTest: XCTestCase {

    func testWorks() {
        let result = process("Name", folder: "../test_data/")
        XCTAssert(result == EXIT_SUCCESS, "It works")
    }
}
