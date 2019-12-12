//
//  SyncTunesPresenter.swift
//  SyncTunes
//
//  Created by Joshua Buhler on 11/27/19.
//  Copyright © 2019 buhler.me. All rights reserved.
//

import Foundation

class SyncTunesPresenter {
    
    
    private var _playlists:[Playlist]
    public var playlists:[Playlist] {
        get {
            return _playlists
        }
    }
    
    private var _tracks:[Track]
    public var tracks:[Track] {
        get {
            return _tracks
        }
    }
    
    init() {
        _playlists = [Playlist]()
        _tracks = [Track]()
    }
    
    func addPlaylistFile (fileURL:URL) {
        let plist = Playlist()
        plist.loadFile(fileURL)
        plist.processPlaylist()
        
        _playlists.append(plist)
    }
    
    func refreshTrackList () {
        
        _tracks.removeAll()
        
        for p in _playlists {
            _tracks.append(contentsOf: p.tracks)
        }
    }
    
    func trimPathAncestors () {
        var pathCompsToTrim = 0
        
        // at most, we'll trim 10 path components
        for i in 0..<10 {
            
            var cPathComp:String = ""
            let t1 = tracks[0]
            if let sourceURL = t1.sourceURL {
                let pathComps = sourceURL.pathComponents
                cPathComp = pathComps[i]
            
                var allMatch = true
                for t in tracks {
                    if let tURL = t.sourceURL {
                        let pathComps = tURL.pathComponents
                        if (pathComps[i] != cPathComp) {
                            // stop looking
                            allMatch = false
                            break
                        }
                    }
                }
                if (allMatch == false) {
                    break
                } else {
                    pathCompsToTrim = i
                }
            }
        }
        
        for t in tracks {
            if let sourceURL = t.sourceURL {
                var startComps = sourceURL.pathComponents
                startComps.removeFirst(pathCompsToTrim)
                
                // update the URL
                var newDestURL = URL(fileURLWithPath: "")
                for c in startComps {
                    newDestURL.appendPathComponent(c)
                }
                t.targetURL = newDestURL
//                t.playlistPath = "\\" + startComps.joined(separator: "\\")
            }
        }
    }
    
    func clearDeletedTracks () {
        
    }
    
    func createOutputDir () {
        
    }
    
    func writePlaylistFiles () {
        
    }
    
    func copyTracksToOutputDir () {
        
    }
    
    func notifyUIThatWereDone () {
        
    }
    
}
