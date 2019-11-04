//
//  SyncTunes.swift
//  SyncTunes
//
//  Created by Joshua Buhler on 4/10/18.
//

import Foundation
import DifferenceKit

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
        
        clearDeletedTracks()
        
        // file ops
        // TODO: remove dupes from copy list
        // TODO: copy remaining list
        
        createOutputDir()
        writePlaylistFiles()
        copyTracksToOutputDir()
        
        ConsoleIO.writeMessage("Done")
    }
    
    func clearDeletedTracks () {
        let sourceURLs = getTrackURLs(trackList: self.tracks)
        let targetURLs = getTargetFileList(targetURL: self.outputURL)
        
        let diffList = StagedChangeset(source: targetURLs, target: sourceURLs)
        
        print ("diff: \(diffList)")
        
        var toDelete:[URL] = [URL]()
        for change in diffList {
            for del in change.elementDeleted {
                let url = targetURLs[del.element]
                toDelete.append(url)
            }
        }
        
        let fileMan = FileManager.default
        for delURL in toDelete {
            do {
                try fileMan.removeItem(at: delURL)
                
                // isn't this why I created TrackDeleteOperation? Is that needed?
                // after each deletion, look at the dir - is it now empty?
                
                let parentDir = delURL.deletingLastPathComponent()
                self.pruneIfEmpty(delURL: parentDir)
            } catch let error {
                print ("⚠️  Failed to delete: \(delURL) - \(error)")
            }
        }
    }
    
    func pruneIfEmpty (delURL:URL) {
        print ("pruneIfEmpty: \(delURL)")
        let fileMan = FileManager.default
        do {
            let dirContents = try fileMan.contentsOfDirectory(at: delURL,
                                                                 includingPropertiesForKeys:nil,
                                                                 options: .skipsHiddenFiles)
            if (dirContents.count == 0) {
                print ("deleting empty: \(delURL)")
                try fileMan.removeItem(at: delURL)
                let parentDir = delURL.deletingLastPathComponent()
                print ("\tparentDir: \(parentDir)")
                self.pruneIfEmpty(delURL: parentDir)
            }
        } catch let e {
            print ("pruneIfEmpty error: \(e)")
        }
    }
    
    func scanInputDirectory () {
        ConsoleIO.writeMessage("Scanning for playlists in \(self.inputURL)")
        
        let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
        let enumerator = FileManager.default.enumerator(at: inputURL,
                                                        includingPropertiesForKeys: resourceKeys,
                                                        options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                            ConsoleIO.writeMessage("scan error at \(url): Error: \(error)", to: .error)
                                                            return true
        })!
        
        for case let fileURL as URL in enumerator {
            
            if (isValidFiletype(fileURL.lastPathComponent)) {
                
                let newPlaylist = Playlist(filePath: fileURL.path)
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
    
    func getTrackURLs (trackList:[Track]) -> [URL] {
        var trackURLS = [URL]()
        
        trackURLS = trackList.map({ (track) -> URL in
            return track.destURL
        })
        
        trackURLS.sort { (t1, t2) -> Bool in
            return t1.path < t2.path
        }
        
        return trackURLS
    }
    
    func createOutputDir (overwriteExisting:Bool = false) {
        // build the output file
        let fileMan = FileManager.default
        
        if (fileMan.fileExists(atPath: self.outputURL.path)) {
            if (overwriteExisting) {
                try? fileMan.removeItem(at: outputURL)
            } else {
                return
            }
        }
        do {
            try fileMan.createDirectory(at: self.outputURL, withIntermediateDirectories: false, attributes: nil)
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
    
    func trimPathAncestors2 (urlList:[URL]) -> [URL] {
        var pathCompsToTrim = 0
        
        // at most, we'll trim 10 path components
        for i in 0..<10 {
            
            var cPathComp:String = ""
            let pathComps = urlList[0].pathComponents
            cPathComp = pathComps[i]
            
            var allMatch = true
            for t in urlList {
                let pathComps = t.pathComponents
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
        
        var trimmedURLs = [URL]()
        for t in urlList {
            var startComps = t.pathComponents
            startComps.removeFirst(pathCompsToTrim)
            
            var newDestURL = outputURL
            for c in startComps {
                newDestURL.appendPathComponent(c)
            }
            trimmedURLs.append(newDestURL)
        }
        return trimmedURLs
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
    
    func getTargetFileList (targetURL:URL) -> [URL] {
        let fileMan = FileManager.default
        
        let resourceKeys = [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey]
        let directoryEnumerator = fileMan.enumerator(at: targetURL,
                                                     includingPropertiesForKeys: resourceKeys,
                                                     options: [.skipsHiddenFiles],
                                                     errorHandler: nil)!
        
        var fileURLs: [URL] = []
        let keySet = Set<URLResourceKey>([URLResourceKey.isDirectoryKey])
        for case let fileURL as URL in directoryEnumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: keySet),
                let isDirectory = resourceValues.isDirectory
                else {
                    continue
            }
            
            if (!isDirectory) {
                fileURLs.append(fileURL)
            }
        }
        
        return fileURLs
    }
    
    func pruneEmptyDirs (targetURL:URL) -> [URL] {
        let fileMan = FileManager.default
        
        let resourceKeys = [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey]
        let directoryEnumerator = fileMan.enumerator(at: targetURL,
                                                     includingPropertiesForKeys: resourceKeys,
                                                     options: [.skipsHiddenFiles],
                                                     errorHandler: nil)!
        
        var fileURLs: [URL] = []
        let keySet = Set<URLResourceKey>([URLResourceKey.isDirectoryKey])
        for case let fileURL as URL in directoryEnumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: keySet),
                let isDirectory = resourceValues.isDirectory
                else {
                    continue
            }
            
            if (!isDirectory) {
                fileURLs.append(fileURL)
            }
        }
        
        return fileURLs
    }
}

extension URL: Differentiable {}
