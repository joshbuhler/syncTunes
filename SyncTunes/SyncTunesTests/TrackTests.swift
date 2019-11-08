//
//  TrackTests.swift
//  SyncTunesTests
//
//  Created by Joshua Buhler on 11/8/19.
//  Copyright © 2019 buhler.me. All rights reserved.
//

import XCTest
@testable import SyncTunes

class TrackTests: XCTestCase {

    let t1_text = "#EXTINF:37,Journey to Austria - John Williams\r/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.mp3"
    
    let t2_text = "#EXTINF:38,Humiliation (Original Arcade Soundtrack) - Robin Beanland\r/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Compilations/Killer Instinct_ Season One Soundtrack + Original Arcade Soundtrack/27 Humiliation (Original Arcade Soundtrack).m4a"
    
    let t3_text = "#EXTINF:38,Matterhorn climbers announcements - Unknown\r/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Unknown/Untitled - 11-15-05 (3)/06 Matterhorn climbers announcements.WMA"
    
    let t4_text = "#EXTINF:38,We're Off to See the Wizard - Judy Garland\r/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Compilations/The Wizard of Oz/16 We're Off to See the Wizard.wav"
    
    let t5_text = "#EXTINF:38,Coco Intro - woodrowgerber\r/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/woodrowgerber/XO/01 Coco Intro.m4b"
    
    let t6_text = "#EXTINF:38,Matterhorn climbers announcements - Unknown\r/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Unknown/Untitled - 11-15-05 (3)/06 Matterhorn climbers announcements.aac"

    let t7_text = "#EXTINF:37,Journey to Austria - John Williams\r/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.flac"
    
    // unsupported type
    let t8_text = "#EXTINF:37,Journey to Austria - John Williams\r/Users/joshuabuhler/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.xyz"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_supportedType () {
        
        // supported file types
        let t1 = Track(trackTxt: t1_text)
        XCTAssertTrue(t1.isSupportedType, "mp3 should be a supported type")
        
        let t2 = Track(trackTxt: t2_text)
        XCTAssertTrue(t2.isSupportedType, "m4a should be a supported type")
        
        let t3 = Track(trackTxt: t1_text)
        XCTAssertTrue(t3.isSupportedType, "wma should be a supported type")
        
        let t4 = Track(trackTxt: t1_text)
        XCTAssertTrue(t4.isSupportedType, "wav should be a supported type")
        
        let t5 = Track(trackTxt: t1_text)
        XCTAssertTrue(t5.isSupportedType, "m4b should be a supported type")
        
        let t6 = Track(trackTxt: t1_text)
        XCTAssertTrue(t6.isSupportedType, "aac should be a supported type")
        
        let t7 = Track(trackTxt: t1_text)
        XCTAssertTrue(t7.isSupportedType, "flac should be a supported type")
        
        // unsupported file types
        let t8 = Track(trackTxt: t8_text)
        XCTAssertFalse(t8.isSupportedType, "XYZ should NOT be a supported type")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
