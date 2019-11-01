//
//  SyncTunesTests.swift
//  syncTunesTests
//
//  Created by Joshua Buhler on 11/1/19.
//  Copyright © 2019 Joshua Buhler. All rights reserved.
//

import XCTest
@testable import syncTunes

class SyncTunesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getTargetFileList () {
        let inputDir:String = ""
        let outputPath:String = ""
        
        let st = SyncTunes(inputDir: inputDir,
                           outputPath: outputPath)
        
        let bundle = Bundle(for: type(of: self)).bundleURL.appendingPathComponent("Contents/Resources", isDirectory: true)
        let targetFiles = st.getTargetFileList(targetURL: bundle)
        print ("targetFiles: \(targetFiles)")
        XCTAssertTrue(targetFiles.count > 0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
