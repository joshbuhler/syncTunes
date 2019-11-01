//
//  TrackCopyOperation.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/15/18.
//

import Cocoa
import RevHash

enum TrackOperationType {
    case copy
    case delete
}

class TrackCopyOperation: Operation, FileManagerDelegate {

    let operationType:TrackOperationType = .copy
    
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
            
//            ConsoleIO.writeMessage("Copying \(trackNum)/\(trackCount): \(destURL.lastPathComponent)")
//            ConsoleIO.writeMessage("\t from: \(sourceURL)")
//            ConsoleIO.writeMessage("\t to: \(destURL)")
            
            print("Copying \(trackNum)/\(trackCount): \(destURL.lastPathComponent)")
            print("\t from: \(sourceURL)")
            print("\t to: \(destURL)")
            
            let dirPath = dirPathComps.joined(separator: "/")
            
            try fileMan.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            
//            let hash = revHash(of: sourceURL.path)
//            print ("[hash] \(hash)")
            
            do {
                let sourceHash = revHash(of: try Data(contentsOf: sourceURL))
                print ("[hash3] source data: \(sourceHash)")
                
                let destHash = revHash(of: try Data(contentsOf: destURL))
                print ("[hash3] dest data: \(destHash)")
            } catch let error {
                print ("[hash] hashError: \(error)")
            }
            
            
            try fileMan.copyItem(atPath: sourceURL.path, toPath: destURL.path)
            
            
        } catch let e {
            ConsoleIO.writeMessage("ERROR copying file: \(e.localizedDescription)")
        }
    }
}

class TrackDeleteOperation: Operation, FileManagerDelegate {

    let operationType:TrackOperationType = .delete
    
    let targetURL:URL
    
    var trackNum:Int = 0
    var trackCount:Int = 0
    
    init(target:URL) {
        targetURL = target
    }
    
    override func main() {
        if (self.isCancelled) {
            return
        }
        
        let fileMan = FileManager.default
        do {
            var dirPathComps = targetURL.pathComponents
            dirPathComps.removeLast()
            
//            ConsoleIO.writeMessage("Copying \(trackNum)/\(trackCount): \(destURL.lastPathComponent)")
//            ConsoleIO.writeMessage("\t from: \(sourceURL)")
//            ConsoleIO.writeMessage("\t to: \(destURL)")
            
            print("deleting \(trackNum)/\(trackCount): \(targetURL.lastPathComponent)")
            print("\t to: \(targetURL)")
            
            try fileMan.removeItem(at: targetURL)
        } catch let e {
            ConsoleIO.writeMessage("ERROR deleting file: \(e.localizedDescription)")
        }
    }
}
