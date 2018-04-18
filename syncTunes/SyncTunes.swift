//
//  SyncTunes.swift
//  SyncTunes
//
//  Created by Joshua Buhler on 4/10/18.
//

import Foundation

enum OptionType {
    case inputPath(String)
    case outputPath(String)
    case unknown
    
    init(option: String, value:String = "") {
        switch option {
        case "i": self = .inputPath(value)
        case "o": self = .outputPath(value)
        default: self = .unknown
        }
    }
}

class SyncTunes {
    
    let inputURL:URL
    let outputURL:URL
    
    var playlists:[Playlist] = [Playlist]()
    var tracks:[Track] = [Track]()
    
    init(inputDir:String, outputPath:String) {
        self.inputURL = URL.init(fileURLWithPath: inputDir)
        self.outputURL = URL.init(fileURLWithPath: outputPath)
    }
    
    static func getOption (_ option: String, value: String) -> OptionType {
        return (OptionType(option: option, value: value))
    }
    
    func processInputDir () {
        scanInputDirectory()
        
        for p in playlists {
            p.processPlaylist()
        }
        
        buildTrackList()
        trimPathAncestors()
        
        // file ops
        createOutputDir()
        writePlaylistFiles()
        copyTracksToOutputDir()
        
        ConsoleIO.writeMessage("Done")
    }
    
    func scanInputDirectory () {
        ConsoleIO.writeMessage("Scanning for playlists in \(inputDir)")
        
        let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
        let enumerator = FileManager.default.enumerator(at: inputURL,
                                                        includingPropertiesForKeys: resourceKeys,
                                                        options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                            ConsoleIO.writeMessage("scan error at \(url): Error: \(error)", to: .error)
                                                            return true
        })!
        
        for case let fileURL as URL in enumerator {
            
            if (isValidFiletype(fileURL.lastPathComponent)) {
                
                let newPlaylist = Playlist(filePath: fileURL.path, destURL:outputURL)
                playlists.append(newPlaylist)
            }
        }
        
        ConsoleIO.writeMessage("Found \(playlists.count) files")
    }
    
    func isValidFiletype (_ fileName:String) -> Bool {
        return ((fileName.lowercased().range(of: "m3u") != nil) ||
            (fileName.lowercased().range(of: "m3u8") != nil))
    }
    
    func buildTrackList () {
        tracks.removeAll()
        
        for p in playlists {
            tracks.append(contentsOf: p.tracks)
            print ("totalTracks: \(tracks.count)")
        }
    }
    
    func createOutputDir () {
        let outputURL = URL.init(fileURLWithPath: outputPath)
        
        // build the output file
        let fileMan = FileManager.default
        
        if (fileMan.fileExists(atPath: outputPath)) {
            try? fileMan.removeItem(at: outputURL)
        }
        
        do {
            try fileMan.createDirectory(at: outputURL, withIntermediateDirectories: false, attributes: nil)
        } catch let e {
            print ("ERROR: \(e)")
            return
        }
    }
    
    func writePlaylistFiles () {
        
        for p in playlists {
            let outputPlistName = p.fileName!
            let outputFileURL = outputURL.appendingPathComponent(outputPlistName)
            
            let outputString = p.getPlaylistString()
            
            do {
                try outputString.write(to: outputFileURL, atomically: true, encoding: .utf8)
                ConsoleIO.writeMessage("File written to: \(outputFileURL)")
            } catch let e {
                ConsoleIO.writeMessage("Error writing strings file: \(e)", to: .error)
            }
        }
    }
    
    func trimPathAncestors () {
        var pathCompsToTrim = 0
        
        // at most, we'll trim 10 path components
        for i in 0..<10 {
            
            var cPathComp:String = ""
            let t1 = tracks[0]
            let pathComps = t1.sourceURL.pathComponents
            cPathComp = pathComps[i]
            
            var allMatch = true
            for t in tracks {
                let pathComps = t.sourceURL.pathComponents
                if (pathComps[i] != cPathComp) {
                    // stop looking
                    allMatch = false
                    break
                }
            }
            
            if (allMatch == false) {
                break
            } else {
                pathCompsToTrim = i
            }
        }
        
        for t in tracks {
            var startComps = t.sourceURL.pathComponents
            startComps.removeFirst(pathCompsToTrim)
            
            var newDestURL = outputURL
            for c in startComps {
                newDestURL.appendPathComponent(c)
            }
            t.destURL = newDestURL
            t.playlistPath = "\\" + startComps.joined(separator: "\\")
        }
    }
    
    let copyQueue:OperationQueue = OperationQueue()
    func copyTracksToOutputDir () {
        var trackNum = 1
        for t in tracks {
            let copyOp = TrackCopyOperation(source: t.sourceURL, dest: t.destURL)
            copyOp.trackNum = trackNum
            copyOp.trackCount = tracks.count
            copyQueue.addOperation(copyOp)
            trackNum += 1
        }
        copyQueue.waitUntilAllOperationsAreFinished()
    }
}
