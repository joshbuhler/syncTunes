//
//  Playlist.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/17/18.
//

import Cocoa

class Playlist {
    
    let filePath:String
    var fileName:String?
    
    
    var tracks:[Track] = [Track]()

    // Most of the guts of SyncTunes will be moved here. This will handle the parsing of a playlist file, track creation, and a toString() method for writing the playlist file. syncTunes can handle the actual file writing.
    // SyncTunes will also be responsible for scanning a directory, and feeding the files to Playlist
    
    init(filePath:String) {
        self.filePath = filePath
    }
    
    func openFile (_ playlistFile:String) -> String? {
        do {
            let textURL = URL.init(fileURLWithPath: playlistFile)
            let textString = try String.init(contentsOf: textURL, encoding: .utf8)
            return textString
        } catch let error {
            ConsoleIO.writeMessage(error.localizedDescription, to: .error)
            return nil
        }
    }
    
    func processPlaylist () {
        ConsoleIO.writeMessage("Scanning playlist file: \(self.filePath)")

        guard let playlistText = self.openFile(self.filePath) else {
            print ("ERROR: playlistText is empty")
            return
        }

        splitIntoTracks(pText: playlistText)
    }
    
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
}
