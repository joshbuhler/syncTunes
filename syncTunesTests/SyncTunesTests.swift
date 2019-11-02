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
    
    func test_getTrackURLs () {
        
        let ta_text = """
        #EXTINF:37,t1 - a1\r/path/to/track/a.mp3
        """
        
        let tb_text = """
        #EXTINF:37,t1 - b1\r/path/to/track/b.mp3
        """
        
        let tc_text = """
        #EXTINF:37,t1 - c1\r/path/to/track/c.mp3
        """
        
        let td_text = """
        #EXTINF:37,t1 - d1\r/path/to/track/d.mp3
        """
        
        let te_text = """
        #EXTINF:37,t1 - e1\r/path/to/track/e.mp3
        """
        
        let t1 = Track(trackTxt: ta_text)
        let t2 = Track(trackTxt: tb_text)
        let t3 = Track(trackTxt: tc_text)
        let t4 = Track(trackTxt: td_text)
        let t5 = Track(trackTxt: te_text)
        
        let trackList = [t2, t1, t3, t5, t4]
        let correctList = [t1.sourceURL,
                           t2.sourceURL,
                           t3.sourceURL,
                           t4.sourceURL,
                           t5.sourceURL]
        
        let inputDir:String = ""
        let outputPath:String = ""
        
        let st = SyncTunes(inputDir: inputDir,
                           outputPath: outputPath)
        
        let sortedTracks = st.getTrackURLs(trackList: trackList)
        
        XCTAssertEqual(correctList, sortedTracks)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
