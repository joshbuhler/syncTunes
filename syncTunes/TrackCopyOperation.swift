//
//  TrackCopyOperation.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/15/18.
//

import Cocoa

class TrackCopyOperation: Operation, FileManagerDelegate {

    let sourceURL:URL
    let destURL:URL
    
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
            
            let dirPath = dirPathComps.joined(separator: "/")
            
            try fileMan.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            
            try fileMan.copyItem(atPath: sourceURL.path, toPath: destURL.path)
        } catch let e {
            print ("ERROR copying file: \(e.localizedDescription)")
        }
    }
}
