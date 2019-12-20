//
//  Playlist.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/17/18.
//

import Cocoa

class Playlist {
    
    public private(set) var fileURL:URL?

    var fileName:String? {
        get {
            guard let lastComp = fileURL?.lastPathComponent else {
                return nil
            }
            
            return lastComp
        }
    }
    
    public private(set) var fileText:String?
    
    public private(set) var tracks:[Track] = [Track]()
    
    public private(set) var unsupportedTracks:[Track] = [Track]()

    // Most of the guts of SyncTunes will be moved here. This will handle the parsing of a playlist file, track creation, and a toString() method for writing the playlist file. syncTunes can handle the actual file writing.
    // SyncTunes will also be responsible for scanning a directory, and feeding the files to Playlist
    
    convenience init(playlistText:String) {
        self.init()        
        fileText = playlistText
    }    
    
    @discardableResult func loadFile (_ file:URL) -> Bool {
        
        let fName = file.lastPathComponent
        if (SupportedPlaylistFileType.checkFileType(txt: fName) == false) {
            let errorMsg  = "⚠️  Unsupported file type: \(self.fileName ?? "")"
            print (errorMsg)
            ConsoleIO.writeMessage(errorMsg, to: .error)
            return false
        }
        
        self.fileURL = file
        
        do {
            fileText = try String.init(contentsOf: file, encoding: .utf8)
        } catch let error {
            
            let errorMsg  = "🛑  ERROR loading contents of file: \(file) - Error: \(error)"
            print (errorMsg)
            ConsoleIO.writeMessage(errorMsg, to: .error)
            return false
        }
        
        return true
    }
    
    func processPlaylist () {
        
        guard var fileText = self.fileText else {
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
                tracks.append(newTrack)
            } else {
                unsupportedTracks.append(newTrack)
            }
        }
        
        print ("✅   Found \(tracks.count) tracks in \(self.fileName ?? "")")
        if (unsupportedTracks.count > 0) {
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
