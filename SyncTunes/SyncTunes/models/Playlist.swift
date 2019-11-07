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

    // Most of the guts of SyncTunes will be moved here. This will handle the parsing of a playlist file, track creation, and a toString() method for writing the playlist file. syncTunes can handle the actual file writing.
    // SyncTunes will also be responsible for scanning a directory, and feeding the files to Playlist
    
    
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
        
        guard let fileText = self._fileText else {
            let errorMsg  = "⚠️  `fileText` was empty for: \(String(describing: self.fileName))"
            print (errorMsg)
            ConsoleIO.writeMessage(errorMsg, to: .error)
            return
        }
        
        let trackStrings = fileText.components(separatedBy: "#EXTINF:")
        
        for t in trackStrings {
            let newTrack = Track(trackTxt: t)
            if (newTrack.supportedType) {
                _tracklist.append(newTrack)
            }
        }
        
        print ("Found \(tracks.count) tracks in \(String(describing:self.fileName))")
    }
    
    // Writes the tracks back into a playlist
    func getPlaylistString () -> String {
        var outputString = "#EXTM3U\n"
        
        for t in tracks {
            outputString += t.toString()
            outputString += "\n"
        }
        
        return outputString
    }
}
