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
        
        XCTAssertNotNil(plist_1.fileURL, "Playlist file was nil")
        XCTAssertNotNil(plist_1.fileName, "Playlist filename was nil")
        XCTAssertNotNil(plist_1.fileText, "Playlist fileText was nil")
        
        // What if the file dosen't exist?
        let url_missing = getPlaylistURL(filename: "missing.m3u")
        let plist_missing = Playlist()
        plist_missing.loadFile(url_missing)
        
        XCTAssertNotNil(plist_missing.fileURL, "Playlist file was nil")
        XCTAssertNotNil(plist_missing.fileName, "Playlist filename was nil")
        XCTAssertNil(plist_missing.fileText, "Playlist fileText was not nil")
    }
    
    func test_processPlaylist () {
        
        // Playlist file 1
        let url_1 = getPlaylistURL(filename: "TestPlaylist.m3u")
        let plist_1 = Playlist()
        plist_1.loadFile(url_1)
        plist_1.processPlaylist()
        
        var trackCount = plist_1.tracks.count
        var expected = 7
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) tracks, expected \(expected)")
        trackCount = plist_1.unsupportedTracks.count
        expected = 0
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) unsupported tracks, expected \(expected)")
        
        // Playlist file 2 - contains a mix of supported and unsupported tracks
        let url_2 = getPlaylistURL(filename: "x.m3u")
        let plist_2 = Playlist()
        plist_2.loadFile(url_2)
        plist_2.processPlaylist()
        
        trackCount = plist_2.tracks.count
        expected = 470
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) tracks, expected \(expected)")
        trackCount = plist_2.unsupportedTracks.count
        expected = 40
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) unsupported tracks, expected \(expected)")
        
        // Playlist file 3
        let url_3 = getPlaylistURL(filename: "Zamboni.m3u")
        let plist_3 = Playlist()
        plist_3.loadFile(url_3)
        plist_3.processPlaylist()
        
        trackCount = plist_3.tracks.count
        expected = 90
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) tracks, expected \(expected)")
        trackCount = plist_3.unsupportedTracks.count
        expected = 0
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) unsupported tracks, expected \(expected)")
        
        // Playlist file missing
        let url_missing = getPlaylistURL(filename: "missing.m3u")
        let plist_missing = Playlist()
        plist_missing.loadFile(url_missing)
        plist_missing.processPlaylist()
        
        trackCount = plist_missing.tracks.count
        expected = 0
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) tracks, expected \(expected)")
        
        // Playlist processing skipped
        let url_skipped = getPlaylistURL(filename: "x.m3u")
        let plist_skipped = Playlist()
        plist_skipped.loadFile(url_skipped)
        // skipping processing here
        
        trackCount = plist_skipped.tracks.count
        expected = 0
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) tracks, expected \(expected)")
        
        // What if no file is loaded?
        let plist_empty = Playlist()
        plist_empty.processPlaylist()
        trackCount = plist_empty.tracks.count
        expected = 0
        XCTAssertEqual(trackCount, expected, "Found \(trackCount) tracks, expected \(expected)")
    }

    func test_performance_processPlaylist () {
        let url_2 = getPlaylistURL(filename: "x.m3u")
        
        let plist_2 = Playlist()
        plist_2.loadFile(url_2)
        
        self.measure {
            // Put the code you want to measure the time of here.
            plist_2.processPlaylist()
        }
    }
    
    // This test will fail until Track parsing is fixed.
//    func test_getPlaylistString () {
//        let url_1 = getPlaylistURL(filename: "TestPlaylist.m3u")
//        let plist_1 = Playlist()
//        plist_1.loadFile(url_1)
//        plist_1.processPlaylist()
//        
//        var inputTrackCount = plist_1.tracks.count
//        var expectedSupported = 7
//        var expectedUnsupported = 0
//        XCTAssertEqual(inputTrackCount, expectedSupported, "Found \(inputTrackCount) tracks, expected \(expectedSupported)")
//        inputTrackCount = plist_1.unsupportedTracks.count
//        XCTAssertEqual(inputTrackCount, expectedUnsupported, "Found \(inputTrackCount) unsupported tracks, expected \(expectedUnsupported)")
//        
//        /**
//            Only going to compare track counts here, as Track will do some work on the URLs, meaning that the output isn't going to match the input 100%. At minimum though, the number of tracks in the output should match the input, minus any unsupported tracks.\
//         */
//        
//        var outputFileText = plist_1.getPlaylistString()
//        XCTAssertTrue(outputFileText.isEmpty == false, "Output playlist text was empty")
//        
//        var outputPlaylist = Playlist(playlistText: outputFileText)
//        outputPlaylist.processPlaylist()
//        
//        var outputTrackCount = outputPlaylist.tracks.count
//        XCTAssertEqual(outputTrackCount, expectedSupported, "Found \(outputTrackCount) tracks, expected \(expectedSupported)")
//        outputTrackCount = plist_1.unsupportedTracks.count
//        XCTAssertEqual(outputTrackCount, expectedUnsupported, "Found \(outputTrackCount) unsupported tracks, expected \(expectedUnsupported)")
//        
//        XCTAssertEqual(inputTrackCount, outputTrackCount, "Input & Output track counts do not match")
//        
//        
//        //--------------
//        
//        // Playlist file 2 - contains a mix of supported and unsupported tracks
//        let url_2 = getPlaylistURL(filename: "x.m3u")
//        let plist_2 = Playlist()
//        plist_2.loadFile(url_2)
//        plist_2.processPlaylist()
//        
//        inputTrackCount = plist_2.tracks.count
//        expectedSupported = 470
//        XCTAssertEqual(inputTrackCount, expectedSupported, "Found \(inputTrackCount) tracks, expected \(expectedSupported)")
//        inputTrackCount = plist_2.unsupportedTracks.count
//        expectedUnsupported = 40
//        XCTAssertEqual(inputTrackCount, expectedUnsupported, "Found \(inputTrackCount) unsupported tracks, expected \(expectedUnsupported)")
//        
//        outputFileText = plist_2.getPlaylistString()
//        XCTAssertTrue(outputFileText.isEmpty == false, "Output playlist text was empty")
//        
//        outputPlaylist = Playlist(playlistText: outputFileText)
//        outputPlaylist.processPlaylist()
//        
//        outputTrackCount = outputPlaylist.tracks.count
//        
//        // unsupported will not match, as we don't include those in this output method
//        expectedUnsupported = 0
//        XCTAssertEqual(outputTrackCount, expectedSupported, "Found \(outputTrackCount) tracks, expected \(expectedSupported)")
//        outputTrackCount = plist_2.unsupportedTracks.count
//        XCTAssertEqual(outputTrackCount, expectedUnsupported, "Found \(outputTrackCount) unsupported tracks, expected \(expectedUnsupported)")
//        
//        XCTAssertEqual(inputTrackCount, outputTrackCount, "Input & Output track counts do not match")
//    }

}
