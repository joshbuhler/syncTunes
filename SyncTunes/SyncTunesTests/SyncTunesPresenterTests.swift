//
//  SyncTunesPresenterTests.swift
//  SyncTunesTests
//
//  Created by Joshua Buhler on 11/7/19.
//  Copyright © 2019 buhler.me. All rights reserved.
//

import XCTest
@testable import SyncTunes

class SyncTunesPresenterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_init () {
        let presenter = SyncTunesPresenter ()
        XCTAssertNotNil(presenter)
    }

}
