import XCTest

import NIOCronSchedulerTests

var tests = [XCTestCaseEntry]()
tests += NIOCronSchedulerTests.allTests()
XCTMain(tests)