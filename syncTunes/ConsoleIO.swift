//
//  ConsoleIO.swift
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO {
    static func writeMessage(_ message: String, to: OutputType = .standard) {
        
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
    
    static func printUsage() {
        
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("usage:")
        writeMessage("\(executableName) -i path/to/input/file -o path/to/output/dir")
//        writeMessage("or")
//        writeMessage("\(executableName) -h to show usage information")
        writeMessage("\n")
        writeMessage("To use syncTunes, you must supply the path to a .m3u playlist, and a destination path for the resulting output files.")
        writeMessage("\t- Input path MUST be a .m3u file.")
        writeMessage("\t- Output path MUST be a full path to the location of the output directory. If the directory does not exist, a new one will be created. In this directory, a new .m3u file will created, and copies of the files listed in the playlist will be added.")
        writeMessage("\n")
    }
}
