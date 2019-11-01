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
    
    func buildTestDir () {
        let bundleURL = Bundle(for: type(of: self)).bundleURL.appendingPathComponent("Contents/Resources", isDirectory: true)
        
        let fileMan = FileManager.default
        
        if (fileMan.fileExists(atPath: bundleURL.absoluteString)) {
            try? fileMan.removeItem(at: bundleURL)
        }
        
        do {
            try fileMan.createDirectory(at: bundleURL,
                                        withIntermediateDirectories: false,
                                        attributes: nil)
        } catch let e {
            print ("ERROR: \(e)")
            return
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getTargetFileList () {
        let inputDir:String = ""
        let outputPath:String = ""
        
        let st = SyncTunes(inputDir: inputDir,
                           outputPath: outputPath)
        
        let bundle = Bundle(for: type(of: self)).bundleURL.appendingPathComponent("Contents/Resources/TestOutputDir", isDirectory: true)
        let targetFiles = st.getTargetFileList(targetURL: bundle)
        print ("targetFiles: \(targetFiles)")
        XCTAssertEqual(targetFiles.count, 10)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
