//
//  TrackTests.swift
//  syncTunesTests
//
//  Created by Joshua Buhler on 4/13/18.
//  Copyright © 2018 Joshua Buhler. All rights reserved.
//

import XCTest

class TrackTests: XCTestCase {

    let t1_text = """
                    #EXTINF:37,Journey to Austria - John Williams
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.mp3
                    """
    let t2_text = """
                    #EXTINF:38,Humiliation (Original Arcade Soundtrack) - Robin Beanland
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Compilations/Killer Instinct_ Season One Soundtrack + Original Arcade Soundtrack/27 Humiliation (Original Arcade Soundtrack).m4a
                    """
    
    let t3_text = """
                    #EXTINF:38,Matterhorn climbers announcements - Unknown
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Unknown/Untitled - 11-15-05 (3)/06 Matterhorn climbers announcements.WMA
                    """
    
    let t4_text = """
                    #EXTINF:38,We're Off to See the Wizard - Judy Garland
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Compilations/The Wizard of Oz/16 We're Off to See the Wizard.wav
                    """
    
    let t5_text = """
                    #EXTINF:38,Coco Intro - woodrowgerber
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/woodrowgerber/XO/01 Coco Intro.m4b
                    """
    
    let t6_text = """
                    #EXTINF:38,Matterhorn climbers announcements - Unknown
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Unknown/Untitled - 11-15-05 (3)/06 Matterhorn climbers announcements.aac
                    """

    let t7_text = """
                    #EXTINF:37,Journey to Austria - John Williams
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.flac
                    """
    let t8_text = """
                    #EXTINF:37,Journey to Austria - John Williams
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.MP3
                    """
    let t9_text = """
                    #EXTINF:37,Journey to Austria - John Williams
                    /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.aad
                    """
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_checkFileType () {
        let testTrack = Track(trackTxt: t1_text)
        XCTAssertTrue(testTrack.checkFileType(txt: t1_text))
        XCTAssertTrue(testTrack.checkFileType(txt: t2_text))
        XCTAssertTrue(testTrack.checkFileType(txt: t3_text))
        XCTAssertTrue(testTrack.checkFileType(txt: t4_text))
        XCTAssertTrue(testTrack.checkFileType(txt: t5_text))
        XCTAssertTrue(testTrack.checkFileType(txt: t6_text))
        XCTAssertTrue(testTrack.checkFileType(txt: t7_text))
        XCTAssertTrue(testTrack.checkFileType(txt: t8_text))
        XCTAssertFalse(testTrack.checkFileType(txt: t9_text))
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
