import XCTest

import AlisterSwiftTests

//TODO: Investigate in case of Lunix support
var tests = [XCTestCaseEntry]()
tests += AlisterSwiftTests.allTests()
XCTMain(tests)
