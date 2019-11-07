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
    
    var tracks:[Track] = [Track]()

    // Most of the guts of SyncTunes will be moved here. This will handle the parsing of a playlist file, track creation, and a toString() method for writing the playlist file. syncTunes can handle the actual file writing.
    // SyncTunes will also be responsible for scanning a directory, and feeding the files to Playlist
    
    
    func loadFile (_ file:URL) {
        self._fileURL = file
        
        do {
            _fileText = try String.init(contentsOf: file, encoding: .utf8)
        } catch let error {
            
            let errorMsg  = "🛑  ERROR loading contents of file: \(file) - Error: \(error)"
            print (errorMsg)
            
            ConsoleIO.writeMessage(error.localizedDescription, to: .error)
        }
    }
    
    func openFile (_ playlistFile:String) -> String? {
//        do {
//            let textURL = URL.init(fileURLWithPath: playlistFile)
//
//            self.fileName = textURL.lastPathComponent
//
//            let textString = try String.init(contentsOf: textURL, encoding: .utf8)
//            return textString
//        } catch let error {
//            ConsoleIO.writeMessage(error.localizedDescription, to: .error)
//            return nil
//        }
        return nil
    }
    
//    func processPlaylist () {
//        ConsoleIO.writeMessage("Scanning playlist file: \(self.file)")
//
//        guard let playlistText = self.openFile(self.file) else {
//            print ("ERROR: playlistText is empty")
//            return
//        }
//
//        splitIntoTracks(pText: playlistText)
//    }
    
    func splitIntoTracks (pText:String) {
        let trackStrings = pText.components(separatedBy: "#EXTINF:")
        
        for t in trackStrings {
            
            let newTrack = Track(trackTxt: t)
            if (newTrack.supportedType) {
                tracks.append(newTrack)
            }
        }
        
        print ("Found \(tracks.count) tracks")
    }
    
    func getPlaylistString () -> String {
        var outputString = "#EXTM3U\n"
        
        for t in tracks {
            outputString += t.toString()
            outputString += "\n"
        }
        
        return outputString
    }
}
