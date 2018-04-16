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
    
    var tracksFound:[Track] = [Track]()
    
    init(inputDir:String, outputPath:String) {
        self.inputURL = URL.init(fileURLWithPath: inputDir)
        self.outputURL = URL.init(fileURLWithPath: outputPath)
    }
    
    static func getOption (_ option: String, value: String) -> OptionType {
        return (OptionType(option: option, value: value))
    }
    
    func openFile (_ playlistFile:URL) -> String? {
        do {
            let textString = try String.init(contentsOf: self.inputURL, encoding: .utf8)
            return textString
        } catch let error {
            ConsoleIO.writeMessage(error.localizedDescription, to: .error)
            return nil
        }
    }
    
    func processInputFile () {
        ConsoleIO.writeMessage("Scanning playlist file: \(inputFile)")
        
        guard let playlistText = self.openFile(self.inputURL) else {
            print ("ERROR: playlistText is empty")
            return
        }
        
        splitIntoTracks(pText: playlistText)
        
        // TODO: create output dir
        // TODO: write new playlist to output dir
        // TODO: rewrite track paths to be the root of the output dir
        // TODO: setup operations to copy tracks to output dir
    }
    
    func doIt () {
        createOutputDir()
        copyTracksToOutputDir()
        writeOutputFile()
    }
    
    func splitIntoTracks (pText:String) {
        let trackStrings = pText.components(separatedBy: "#EXTINF:")
        
        for t in trackStrings {
            
            let newTrack = Track(trackTxt: t)
            if (newTrack.supportedType) {
                tracksFound.append(newTrack)
            }
        }
        
        print ("Found \(tracksFound.count) tracks")
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
    
    func writeOutputFile () {
        
        let outputPlistName = inputURL.lastPathComponent
        let outputFileURL = outputURL.appendingPathComponent(outputPlistName)
        
        var outputString = "#EXTM3U\n"
        
        for t in tracksFound {
            outputString += t.toString()
            outputString += "\n"
        }
        
        do {
            try outputString.write(to: outputFileURL, atomically: true, encoding: .utf8)
            ConsoleIO.writeMessage("File written to: \(outputFileURL)")
        } catch let e {
            ConsoleIO.writeMessage("Error writing strings file: \(e)", to: .error)
        }
    }
    
    
    let copyQueue:OperationQueue = OperationQueue()
    func copyTracksToOutputDir () {
        
        trimPathAncestors()
        
        for t in tracksFound {
            let copyOp = TrackCopyOperation(source: t.sourceURL, dest: t.destURL)
            copyQueue.addOperation(copyOp)
        }
    }
    
    func trimPathAncestors () {
        var pathCompsToTrim = 0
        
        // at most, we'll trim 10
        for i in 0..<10 {
            
            var cPathComp:String = ""
            let t1 = tracksFound[0]
            let pathComps = t1.sourceURL.pathComponents
            cPathComp = pathComps[i]
            
            var allMatch = true
            for t in tracksFound {
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
        
        for t in tracksFound {
            var startComps = t.sourceURL.pathComponents
            startComps.removeFirst(pathCompsToTrim)
            
            var newDestURL = outputURL
            for c in startComps {
                newDestURL.appendPathComponent(c)
            }
            t.destURL = newDestURL
            t.playlistPath = "\\" + startComps.joined(separator: "\\")
        }
        
        print ("pathCompsToTrim: \(pathCompsToTrim)")
    }
}


