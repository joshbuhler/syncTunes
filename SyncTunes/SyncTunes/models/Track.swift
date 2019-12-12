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
    private var _sourceURL:URL?
    var sourceURL:URL? {
        get {
            return _sourceURL
        }
    }
    
    // TODO: Should this be part of the copy operation? Does a track care where it's going?
    // Where the track's file is being copied to
//    private var _targetURL:URL?
    var targetURL:URL?
//    {
//        get {
//            return _targetURL
//        }
//    }
    
    var isSupportedType:Bool {
        return SupportedTrackFileType.checkFileType(txt: self._trackText)
    }
    
    private var _trackLength:Int = 0
    var trackLength:Int {
        get {
            return _trackLength
        }
    }
    
    private var _trackName:String = "MISSING_TRACK_NAME"
    var trackName:String {
        get {
            return _trackName
        }
    }
    
    // url written to playlist - originally came from syncTunes.swift
    // TODO: how is this different from targetURL?
    private var _playlistPath:String?
    var playlistPath:String? {
        get {
            return _playlistPath
        }
    }
    
    var trackString:String {
        get {
            var returnString = "#EXTINF:\(self.trackLength),\(self.trackName)"
            returnString += "\r"
            
            // TODO: use the source path until we have the target path
//            if let path = self.playlistPath {
//                returnString += path
//            }
            
            if let path = _sourceURL?.path {
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
                _trackLength = length
            }
            
            if (comps.count >= 2) {
                // just in case the track has "," in it, join the rest back together
                comps.removeFirst()
                _trackName = comps.joined(separator: ",")
            }
        }
        
        // File path
        if (trackComponents.count >= 2) {
            let fileText = trackComponents[1]
            //print ("fileText: \(fileText)")
            _sourceURL = URL(fileURLWithPath: fileText)
        }
    }
}
