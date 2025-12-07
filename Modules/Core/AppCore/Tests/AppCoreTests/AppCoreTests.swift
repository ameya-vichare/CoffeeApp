//
//  AppCoreTests.swift
//  AppCoreTests
//

import XCTest
@testable import AppCore

final class AppCoreTests: XCTestCase {
    func testAppCoreImports() {
        // Test that all modules are accessible through AppCore
        let config = AppConfiguration()
        XCTAssertNotNil(config)
    }
}

