//
//  main.swift
//  syncTunes
//
//  Created by Joshua Buhler on 4/10/18.
//

import Foundation

ConsoleIO.writeMessage("Scanning playlist file...")

if (CommandLine.argc != 5) {
    ConsoleIO.printUsage()
    exit(0)
}

let argument1 = CommandLine.arguments[1]
let argument2 = CommandLine.arguments[2]

let argument3 = CommandLine.arguments[3]
let argument4 = CommandLine.arguments[4]

let param_0 = SyncTunes.getOption(String(argument1[argument1.index(argument1.startIndex, offsetBy: 1)...]), value: argument2)
let param_1 = SyncTunes.getOption(String(argument3[argument3.index(argument3.startIndex, offsetBy: 1)...]), value: argument4)

var inputDir:String = ""
var outputPath:String = ""

func processOption (option:OptionType) {
    switch (option) {
    case let .inputPath(dir):
        inputDir = dir
    case let .outputPath(dir):
        outputPath = dir
    case .unknown:
        ConsoleIO.writeMessage("Unknown option", to: .error)
        exit (0)
    }
}

processOption(option: param_0)
processOption(option: param_1)

let tuneSync = SyncTunes(inputDir: inputDir, outputPath: outputPath)
tuneSync.processInputDir()
