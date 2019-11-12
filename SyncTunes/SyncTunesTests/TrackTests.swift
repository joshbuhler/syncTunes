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

    let t1_text = "#EXTINF:37,Journey to Austria - John Williams\r/path/to/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.mp3"
    
    let t2_text = "#EXTINF:38,Humiliation (Original Arcade Soundtrack) - Robin Beanland\r/path/to/Music/iTunes/iTunes Media/Music/Compilations/Killer Instinct_ Season One Soundtrack + Original Arcade Soundtrack/27 Humiliation (Original Arcade Soundtrack).m4a"
    
    let t3_text = "#EXTINF:38,Matterhorn climbers announcements - Unknown\r/path/to/Music/iTunes/iTunes Media/Music/Unknown/Untitled - 11-15-05 (3)/06 Matterhorn climbers announcements.WMA"
    
    let t4_text = "#EXTINF:38,We're Off to See the Wizard - Judy Garland\r/path/to/Music/iTunes/iTunes Media/Music/Compilations/The Wizard of Oz/16 We're Off to See the Wizard.wav"
    
    let t5_text = "#EXTINF:38,Coco Intro - woodrowgerber\r/path/to/Music/iTunes/iTunes Media/Music/woodrowgerber/XO/01 Coco Intro.m4b"
    
    let t6_text = "#EXTINF:38,Matterhorn climbers announcements - Unknown\r/path/to/Music/iTunes/iTunes Media/Music/Unknown/Untitled - 11-15-05 (3)/06 Matterhorn climbers announcements.aac"

    let t7_text = "#EXTINF:37,Journey, to Austria - John Williams\r/path/to/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.flac"
    
    // unsupported type
    let t8_text = "#EXTINF:37,Journey to Austria - John Williams\r/this/is/an/unsupported/file/type.xyz"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_trackInit () {
        let t1 = Track(trackTxt: t1_text)
        XCTAssertEqual(t1.trackName, "Journey to Austria - John Williams")
        XCTAssertEqual(t1.trackLength, 37)
        XCTAssertTrue(t1.isSupportedType, "mp3 should be a supported type")
        XCTAssertEqual(t1.sourceURL, URL(fileURLWithPath: "/path/to/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.mp3"))
        
        let t2 = Track(trackTxt: t2_text)
        XCTAssertEqual(t2.trackName, "Humiliation (Original Arcade Soundtrack) - Robin Beanland")
        XCTAssertEqual(t2.trackLength, 38)
        XCTAssertTrue(t2.isSupportedType, "mp3 should be a supported type")
        XCTAssertEqual(t2.sourceURL, URL(fileURLWithPath: "/path/to/Music/iTunes/iTunes Media/Music/Compilations/Killer Instinct_ Season One Soundtrack + Original Arcade Soundtrack/27 Humiliation (Original Arcade Soundtrack).m4a"))
        
        let t3 = Track(trackTxt: t3_text)
        XCTAssertEqual(t3.trackName, "Matterhorn climbers announcements - Unknown")
        XCTAssertEqual(t3.trackLength, 38)
        XCTAssertTrue(t3.isSupportedType, "mp3 should be a supported type")
        XCTAssertEqual(t3.sourceURL, URL(fileURLWithPath: "/path/to/Music/iTunes/iTunes Media/Music/Unknown/Untitled - 11-15-05 (3)/06 Matterhorn climbers announcements.WMA"))
        
        let t4 = Track(trackTxt: t4_text)
        XCTAssertEqual(t4.trackName, "We're Off to See the Wizard - Judy Garland")
        XCTAssertEqual(t4.trackLength, 38)
        XCTAssertTrue(t4.isSupportedType, "mp3 should be a supported type")
        XCTAssertEqual(t4.sourceURL, URL(fileURLWithPath: "/path/to/Music/iTunes/iTunes Media/Music/Compilations/The Wizard of Oz/16 We're Off to See the Wizard.wav"))
        
        let t5 = Track(trackTxt: t5_text)
        XCTAssertEqual(t5.trackName, "Coco Intro - woodrowgerber")
        XCTAssertEqual(t5.trackLength, 38)
        XCTAssertTrue(t5.isSupportedType, "mp3 should be a supported type")
        XCTAssertEqual(t5.sourceURL, URL(fileURLWithPath: "/path/to/Music/iTunes/iTunes Media/Music/woodrowgerber/XO/01 Coco Intro.m4b"))
        
        let t6 = Track(trackTxt: t6_text)
        XCTAssertEqual(t6.trackName, "Matterhorn climbers announcements - Unknown")
        XCTAssertEqual(t6.trackLength, 38)
        XCTAssertTrue(t6.isSupportedType, "mp3 should be a supported type")
        XCTAssertEqual(t6.sourceURL, URL(fileURLWithPath: "/path/to/Music/iTunes/iTunes Media/Music/Unknown/Untitled - 11-15-05 (3)/06 Matterhorn climbers announcements.aac"))
        
        let t7 = Track(trackTxt: t7_text)
        XCTAssertEqual(t7.trackName, "Journey, to Austria - John Williams")
        XCTAssertEqual(t7.trackLength, 37)
        XCTAssertTrue(t7.isSupportedType, "mp3 should be a supported type")
        XCTAssertEqual(t7.sourceURL, URL(fileURLWithPath: "/path/to/Music/iTunes/iTunes Media/Music/John Williams/Indiana Jones_ The Soundtracks Collection/3-06 Journey to Austria.flac"))
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

    func test_trackString () {
        
        // Until we start editing track paths for output, we should get out what we put in
        
        let t1 = Track(trackTxt: t1_text)
        XCTAssertEqual(t1.trackString, t1_text)
        
        let t2 = Track(trackTxt: t2_text)
        XCTAssertEqual(t2.trackString, t2_text)
        
        let t3 = Track(trackTxt: t3_text)
        XCTAssertEqual(t3.trackString, t3_text)
        
        let t4 = Track(trackTxt: t4_text)
        XCTAssertEqual(t4.trackString, t4_text)
        
        let t5 = Track(trackTxt: t5_text)
        XCTAssertEqual(t5.trackString, t5_text)
        
        let t6 = Track(trackTxt: t6_text)
        XCTAssertEqual(t6.trackString, t6_text)
        
        let t7 = Track(trackTxt: t7_text)
        XCTAssertEqual(t7.trackString, t7_text)
        
    }

}
