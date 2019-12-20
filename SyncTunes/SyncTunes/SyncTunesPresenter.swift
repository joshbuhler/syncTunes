//
//  SyncTunesPresenter.swift
//  SyncTunes
//
//  Created by Joshua Buhler on 11/27/19.
//  Copyright © 2019 buhler.me. All rights reserved.
//

import Foundation

class SyncTunesPresenter {
    
    
    public private(set) var playlists:[Playlist]
    
    public private(set) var tracks:[Track]
    
    init() {
        playlists = [Playlist]()
        tracks = [Track]()
    }
    
    func addPlaylistFile (fileURL:URL) {
        let plist = Playlist()
        plist.loadFile(fileURL)
        plist.processPlaylist()
        
        playlists.append(plist)
    }
    
    func refreshTrackList () {
        
        tracks.removeAll()
        
        for p in playlists {
            tracks.append(contentsOf: p.tracks)
        }
    }
    
    // Trims up to the closest parent directory. For example, these:
    //
    // /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Martin O'Donnell & Michael Salvatori/Halo 3_ Original Soundtrack/16 Three Gates 1.mp3
    // /Users/joshuabuhler/Music/iTunes/iTunes Media/Music/Original Video Game Soundtrack/Halo Reach_ Original Soundtrack/1-01 Overture.mp3
    // will be trimmed to:
    // /Music/Martin O'Donnell & Michael Salvatori/Halo 3_ Original Soundtrack/16 Three Gates 1.mp3//
    // /Music/Original Video Game Soundtrack/Halo Reach_ Original Soundtrack/1-01 Overture.mp3
    
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
                t.trackPath = startComps.joined(separator: "/")
            }
        }
    }
    
    func clearDeletedTracks () {
        
    }
    
    func createOutputDir (outputURL:URL, overwriteExisting:Bool = false) {
        let fileMan = FileManager.default
        
        if (fileMan.fileExists(atPath: outputURL.path)) {
            if (overwriteExisting) {
                try? fileMan.removeItem(at: outputURL)
            } else {
                return
            }
        }
        do {
            try fileMan.createDirectory(at: outputURL,
                                        withIntermediateDirectories: false,
                                        attributes: nil)
        } catch let e {
            print ("ERROR: \(e)")
            return
        }
    }
    
    func writePlaylistFiles () {
        
    }
    
    func copyTracksToOutputDir () {
        
    }
    
    func notifyUIThatWereDone () {
        
    }
    
}
