//
//  PlaylistTests.swift
//  SyncTunesTests
//
//  Created by Joshua Buhler on 11/7/19.
//  Copyright © 2019 buhler.me. All rights reserved.
//

import XCTest
@testable import SyncTunes

class PlaylistTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func getPlaylistURL (filename:String) -> URL {
        
        let bundleURL = Bundle(for: type(of: self)).bundleURL
        let plistDir = bundleURL.appendingPathComponent("Contents/Resources/TestFiles/playlists", isDirectory: true)
        
        let plistURL = plistDir.appendingPathComponent(filename)
        return plistURL
    }
    
    func test_playlistInit () {
        let plist = Playlist()
        
        XCTAssertNil(plist.fileURL, "Playlist file was not nil")
        XCTAssertNil(plist.fileName, "Playlist filename was not nil")
        XCTAssertNil(plist.fileText, "Playlist fileText was not nil")
    }

    func test_openFile () {
        let url_1 = getPlaylistURL(filename: "x.m3u")
        let plist_1 = Playlist()
        plist_1.loadFile(url_1)
        
        XCTAssertNotNil(plist_1.fileURL)
        XCTAssertNotNil(plist_1.fileName)
        XCTAssertNotNil(plist_1.fileText)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
