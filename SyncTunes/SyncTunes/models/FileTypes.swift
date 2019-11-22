//
//  FileTypes.swift
//  SyncTunes
//
//  Created by Joshua Buhler on 11/21/19.
//  Copyright © 2019 buhler.me. All rights reserved.
//

import Foundation

enum SupportedPlaylistFileType:String, TypeCheckable {
    case m3u = "m3u"
    case m3u8 = "m3u8"
}

enum SupportedTrackFileType:String, TypeCheckable {
    case mp3 = "mp3"
    case m4a = "m4a"
    case wma = "wma"
    case wav = "wav"
    case m4b = "m4b"
    case aac = "aac"
    case flac = "flac"
}

protocol TypeCheckable: CaseIterable {}

extension TypeCheckable where Self : RawRepresentable, Self.RawValue == String {
    static func checkFileType (txt:String) -> Bool {
        
        
        let patternString = self.allCases.map({"\($0.rawValue)"}).joined(separator: "|")
        let pattern = "(\(patternString))"
        
        let fullRange = NSMakeRange(0, txt.count)
        
        do {
            let idRegex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return (idRegex.numberOfMatches(in: txt, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: fullRange) > 0)
            
        } catch let error {
            print ("ERROR: \(error)")
        }
        
        return false
    }
}
