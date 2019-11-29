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
