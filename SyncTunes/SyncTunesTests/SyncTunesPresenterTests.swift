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
    
    func getPlaylistURL (filename:String) -> URL {
        
        let bundleURL = Bundle(for: type(of: self)).bundleURL
        let plistDir = bundleURL.appendingPathComponent("Contents/Resources/TestFiles/playlists", isDirectory: true)
        
        let plistURL = plistDir.appendingPathComponent(filename)
        return plistURL
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Tests
    //*************************************************************************

    func test_init () {
        let presenter = SyncTunesPresenter()
        XCTAssertNotNil(presenter)
    }

    func test_addPlaylist () {
        let presenter = SyncTunesPresenter()
        
        XCTAssertEqual(presenter.playlists.count, 0)
     
        let url_1 = getPlaylistURL(filename: "TestPlaylist.m3u")
        presenter.addPlaylistFile (fileURL: url_1)
        XCTAssertEqual(presenter.playlists.count, 1)
        
        let url_2 = getPlaylistURL(filename: "x.m3u")
        presenter.addPlaylistFile (fileURL: url_2)
        XCTAssertEqual(presenter.playlists.count, 2)
    }
    
    func test_refreshTrackList () {
        // Each playlist added increments the expected track count
        
        let presenter = SyncTunesPresenter()
        
        let url_1 = getPlaylistURL(filename: "TestPlaylist.m3u")
        presenter.addPlaylistFile (fileURL: url_1)
        
        presenter.refreshTrackList()
        XCTAssertEqual(presenter.tracks.count, 7)
        
        let url_2 = getPlaylistURL(filename: "x.m3u")
        presenter.addPlaylistFile (fileURL: url_2)
        
        presenter.refreshTrackList()
        XCTAssertEqual(presenter.tracks.count, 477)
    }
    
    func test_trimPathAncestors () {
        let presenter = SyncTunesPresenter()
        
        let url_2 = getPlaylistURL(filename: "x.m3u")
        presenter.addPlaylistFile (fileURL: url_2)
        
        presenter.refreshTrackList()
        
        let expectedTrackCount = 470
        XCTAssertEqual(presenter.tracks.count, expectedTrackCount)
        
        // Every path in this file begins with `/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/`
        // After trimming, this should not be found in any path
        
        let pathToBeTrimmed = "/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/"
        let pathAsURL = URL(fileURLWithPath: pathToBeTrimmed, isDirectory: true)
        
        let tracks = presenter.tracks
        for t:Track in tracks {
            XCTAssertNotNil(t.sourceURL)
            let pathString = t.sourceURL!.path
            XCTAssertTrue(pathString.contains(pathToBeTrimmed))
            XCTAssertTrue(t.sourceURL!.pathComponents.count > pathAsURL.pathComponents.count)
        }
        
        presenter.trimPathAncestors()
        
        for t:Track in tracks {
            XCTAssertNotNil(t.targetPath)
            let pathString = t.targetPath!
            XCTAssertFalse(pathString.contains(pathToBeTrimmed))
        }
    }
}
