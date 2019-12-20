//
//  Track.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/13/18.
//

import Cocoa

class Track {
    
    private var _trackText:String = ""
    
    // Where the track's file is coming from
    public private(set) var sourceURL:URL?
    
    // The path to the track after having trimmed any extra from the beginning
    var trackPath:String?
    
    var isSupportedType:Bool {
        return SupportedTrackFileType.checkFileType(txt: self._trackText)
    }
    
    public private(set) var trackLength:Int = 0
    
    public private(set) var trackName:String = "MISSING_TRACK_NAME"
    
    // url written to playlist - originally came from syncTunes.swift
    // TODO: how is this different from targetURL?
    public private(set) var playlistPath:String?
    
    var trackString:String {
        get {
            var returnString = "#EXTINF:\(self.trackLength),\(self.trackName)"
            returnString += "\r"
            
            // TODO: use the source path until we have the target path
//            if let path = self.playlistPath {
//                returnString += path
//            }
            
            if let path = sourceURL?.path {
                returnString += path
            }
            
            return returnString
        }
    }
    
    
    init(trackTxt:String) {
        self._trackText = trackTxt
        
        self.parseTrackText()
    }
    
    private func parseTrackText () {
        
        var trackString = _trackText
        if let headerRange = trackString.range(of: "#EXTINF:") {
            trackString.removeSubrange(headerRange)
        }
        
        let trackComponents:[String] = trackString.components(separatedBy: .newlines)
                
        // track metadata
        let metaText:String? = trackComponents[0]
        if let mText = metaText {
            var comps = mText.components(separatedBy: ",")
            
            if let length = Int(comps[0]) {
                trackLength = length
            }
            
            if (comps.count >= 2) {
                // just in case the track has "," in it, join the rest back together
                comps.removeFirst()
                trackName = comps.joined(separator: ",")
            }
        }
        
        // File path
        if (trackComponents.count >= 2) {
            let fileText = trackComponents[1]
            //print ("fileText: \(fileText)")
            sourceURL = URL(fileURLWithPath: fileText)
        }
    }
}
