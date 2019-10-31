//
//  TrackCopyOperation.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/15/18.
//

import Cocoa
import RevHash

class TrackCopyOperation: Operation, FileManagerDelegate {

    let sourceURL:URL
    let destURL:URL
    
    var trackNum:Int = 0
    var trackCount:Int = 0
    
    init(source:URL, dest:URL) {
        sourceURL = source
        destURL = dest
    }
    
    override func main() {
        if (self.isCancelled) {
            return
        }
        
        let fileMan = FileManager.default
        do {
            var dirPathComps = destURL.pathComponents
            dirPathComps.removeLast()
            
            ConsoleIO.writeMessage("Copying \(trackNum)/\(trackCount): \(destURL.lastPathComponent)")
            
            let dirPath = dirPathComps.joined(separator: "/")
            
            try fileMan.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            
            let hash = revHash(of: sourceURL.path)
            print ("[hash] \(hash)")
            
            
            let dataHash = revHash(of: try! Data(contentsOf: sourceURL))
            print ("[hash] data: \(dataHash)")
            
            try fileMan.copyItem(atPath: sourceURL.path, toPath: destURL.path)
            
            
        } catch let e {
            ConsoleIO.writeMessage("ERROR copying file: \(e.localizedDescription)")
        }
    }
}
