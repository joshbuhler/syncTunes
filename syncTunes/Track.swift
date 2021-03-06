//
//  Track.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/13/18.
//

import Cocoa

class Track {
    var trackLength:String?
    var trackName:String?
    var sourceURL:URL! // where the file came from
    var destURL:URL! // where it's being copied to
    var playlistPath:String! // url written to playlist
    
    var supportedType:Bool = false
    
    init(trackTxt:String?) {
        if let t = trackTxt {
            parseTrackTxt(txt: t)
        }
    }
    
    func parseTrackTxt (txt:String) {
        self.supportedType = checkFileType(txt: txt)
        
        let fileText:String? = txt.components(separatedBy: "\r")[1]
        
        if let fText = fileText {
            self.sourceURL = URL(fileURLWithPath: fText)
        }
            
        findTrackMetadata(txt: txt)
    }
    
    func findTrackMetadata (txt:String) {
        
        let metaText:String? = txt.components(separatedBy: "\r")[0]
        
        if let mText = metaText {
            var comps = mText.components(separatedBy: ",")
            
            if (comps.count >= 2) {
                self.trackLength = comps[0]
                
                // just in case the track has "," in it, join the rest back together
                comps.removeFirst()
                self.trackName = comps.joined(separator: ",")
            }
        }
    }
    
    func checkFileType (txt:String) -> Bool {
        let pattern = "(.mp3|.m4a|.wma|.wav|.m4b|.aac|.flac)"
        
        let fullRange = NSMakeRange(0, txt.count)
        
        do {
            let idRegex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return (idRegex.numberOfMatches(in: txt, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: fullRange) > 0)
            
        } catch let error {
            print ("ERROR: \(error)")
        }
        
        return false
    }
    
    func toString () -> String {
        var returnString = "#EXTINF:\(self.trackLength ?? "0"),\(self.trackName ?? "Unknown Track")"
        
        returnString += "\n"
        
        returnString += self.playlistPath
        
        return returnString
    }
    
    
}
