//
//  Playlist.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/17/18.
//

import Cocoa

class Playlist {
    
    private var _fileURL:URL?
    var fileURL:URL? {
        get {
            return _fileURL
        }
    }

    var fileName:String? {
        get {
            guard let lastComp = _fileURL?.lastPathComponent else {
                return nil
            }
            
            return lastComp
        }
    }
    
    private var _fileText:String?
    var fileText:String? {
        get {
            return _fileText
        }
    }
    
    var _tracklist:[Track] = [Track]()
    var tracks:[Track] {
        get {
            return _tracklist
        }
    }
    
    var _unsupportedTracks:[Track] = [Track]()
    var unsupportedTracks:[Track] {
        get {
            return _unsupportedTracks
        }
    }

    // Most of the guts of SyncTunes will be moved here. This will handle the parsing of a playlist file, track creation, and a toString() method for writing the playlist file. syncTunes can handle the actual file writing.
    // SyncTunes will also be responsible for scanning a directory, and feeding the files to Playlist
    
    convenience init(playlistText:String) {
        self.init()        
        _fileText = playlistText
    }
    
    
    func loadFile (_ file:URL) {
        self._fileURL = file
        
        do {
            _fileText = try String.init(contentsOf: file, encoding: .utf8)
        } catch let error {
            
            let errorMsg  = "🛑  ERROR loading contents of file: \(file) - Error: \(error)"
            print (errorMsg)
            ConsoleIO.writeMessage(errorMsg, to: .error)
        }
    }
    
    func processPlaylist () {
        
        guard var fileText = self._fileText else {
            let errorMsg  = "⚠️  `fileText` was empty for: \(self.fileName ?? "")"
            print (errorMsg)
            ConsoleIO.writeMessage(errorMsg, to: .error)
            return
        }
        
        // Let's lose the file header (assuming this file has one)
        if let headerRange = fileText.range(of: "#EXTM3U") {
            fileText.removeSubrange(headerRange)
        }
        fileText = fileText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let trackStrings = fileText.components(separatedBy: "#EXTINF:")
        
        for t in trackStrings {
            if (t.isEmpty) {
                continue
            }
            
            let newTrack = Track(trackTxt: t)
            if (newTrack.isSupportedType) {
                _tracklist.append(newTrack)
            } else {
                _unsupportedTracks.append(newTrack)
            }
        }
        
        print ("✅   Found \(tracks.count) tracks in \(self.fileName ?? "")")
        if (_unsupportedTracks.count > 0) {
            print ("⚠️   Found \(unsupportedTracks.count) unsupported tracks in \(self.fileName ?? "")")
        }
    }
    
    // Writes the tracks back into a playlist
    func getPlaylistString () -> String {
        var outputString = "#EXTM3U\r"
        
        for t in tracks {
            outputString += t.trackString
            outputString += "\r"
        }
        
        return outputString
    }
}
