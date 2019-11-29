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
    
    init() {
        _playlists = [Playlist]()
    }
    
    func addPlaylistFile (fileURL:URL) {
        let plist = Playlist()
        plist.loadFile(fileURL)
        
        _playlists.append(plist)
    }
    
    func buildTrackList () {
        
    }
    
    func trimPathAncestors () {
        
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
