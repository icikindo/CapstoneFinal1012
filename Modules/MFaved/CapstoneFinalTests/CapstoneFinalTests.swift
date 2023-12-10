//
//  CapstoneFinalTests.swift
//  CapstoneFinalTests
//
//  Created by hastu on 05/12/23.
//

import XCTest

final class CapstoneFinalTests: XCTestCase {
    private var sut: SUTester!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SUTester()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testForwardCompatibility() throws {
        XCTAssertTrue(sut.stillCompatible())
    }

    func testLocalSupport() throws {
        let greeting = sut.localize("Hello, world!")
        let salam = "Halo dunia!"
        XCTAssertEqual(greeting, salam)
    }
}
