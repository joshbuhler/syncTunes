//
//  FileTypesTests.swift
//  SyncTunesTests
//
//  Created by Joshua Buhler on 11/22/19.
//  Copyright © 2019 buhler.me. All rights reserved.
//

import XCTest
@testable import SyncTunes

class FileTypesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_supportedType_track () {
        
        // supported file types
        XCTAssertTrue(SupportedTrackFileType.checkFileType(txt: "mp3"), "mp3 should be a supported type")
        
        XCTAssertTrue(SupportedTrackFileType.checkFileType(txt: "m4a"), "m4a should be a supported type")
        
        XCTAssertTrue(SupportedTrackFileType.checkFileType(txt: "wma"), "wma should be a supported type")
        
        XCTAssertTrue(SupportedTrackFileType.checkFileType(txt: "wav"), "wav should be a supported type")
        
        XCTAssertTrue(SupportedTrackFileType.checkFileType(txt: "m4b"), "m4b should be a supported type")
        
        XCTAssertTrue(SupportedTrackFileType.checkFileType(txt: "aac"), "aac should be a supported type")
        
        XCTAssertTrue(SupportedTrackFileType.checkFileType(txt: "flac"), "flac should be a supported type")
        
        // unsupported file types
        XCTAssertFalse(SupportedTrackFileType.checkFileType(txt: "xyz"), "XYZ should NOT be a supported type")
    }

    func test_supportedType_playlist () {
        
        // supported file types
        XCTAssertTrue(SupportedPlaylistFileType.checkFileType(txt: "m3u"), "m3u should be a supported type")
        
        XCTAssertTrue(SupportedPlaylistFileType.checkFileType(txt: "m3u8"), "m3u8 should be a supported type")
        
        // unsupported file types
        XCTAssertFalse(SupportedPlaylistFileType.checkFileType(txt: "xyz"), "XYZ should NOT be a supported type")
    }
}
