//
//  PythonScriptHelper.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 12/6/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Foundation

class PythonScriptHelper {
    func saveToFile(data: Array<Dictionary<String, NSObject>>) {
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        
        let json = JSON(data)
        let str = json.description
        let outputFilename = "messages.json"
        let filename = getDocumentsDirectory().appendingPathComponent(outputFilename)
        
        do {
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to write \(outputFilename). Error: \(error.localizedDescription)")
        }
    }
    func runScript(completionHandler: (String?) -> Void) {
        guard let scriptPath = Bundle.main.path(forResource: "feature_vector", ofType: "py") else {
            completionHandler(nil)
            return
        }
        guard let sentimentAnalysisDatasetFilePath = Bundle.main.path(forResource: "Sentiment Analysis Dataset", ofType: "csv") else {
            completionHandler(nil)
            return
        }
        guard let unigramsFilePath = Bundle.main.path(forResource: "unigrams", ofType: "txt") else {
            completionHandler(nil)
            return
        }
        
        let homeDirectory = NSHomeDirectory()
        let messagesFilePath = "\(homeDirectory)/Documents/messages.json"
        
        var arguments = [scriptPath]
        arguments.append(messagesFilePath)
        arguments.append(sentimentAnalysisDatasetFilePath)
        arguments.append(unigramsFilePath)
//        arguments.append("--dict")
//        arguments.append(dictionaryPath)
//        arguments.append("--pattern")
//        arguments.append(pattern)
//        arguments.append("--minlen")
//        arguments.append("\(minLength)")
//        arguments.append("--maxlen")
//        arguments.append("\(maxLength)")
        
        let outPipe = Pipe()
        let errPipe = Pipe();
        
        let task = Process()
        task.launchPath = "/usr/local/bin/python2"
        task.arguments = arguments
        task.standardInput = Pipe()
        task.standardOutput = outPipe
        task.standardError = errPipe
        task.launch()
        
        let data = outPipe.fileHandleForReading.readDataToEndOfFile()
        let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()
        
        let exitCode = task.terminationStatus
        if (exitCode != 0) {
            print("ERROR: \(exitCode)")
            let errOutput = String(data: errData, encoding: String.Encoding.ascii)
            let output = String(data: data, encoding: String.Encoding.ascii)
            print(output!)
            print(errOutput!)
            completionHandler(nil)
            return
        }
        
        let output = String(data: data, encoding: String.Encoding.ascii)
        completionHandler(output)
    }
    func getLabels() -> [Int64: BinarySentiment] {
        let inputFilename = "labeled_messages.json"
        var labels = [Int64: BinarySentiment]()
        do {
            let fileManager = FileManager.default
            let currentWorkingDirectory = fileManager.currentDirectoryPath
            let pathString = "\(currentWorkingDirectory)/\(inputFilename)"
            let path = URL(fileURLWithPath: pathString)
            let jsonData = try Data(contentsOf: path)
            let json = JSON(data: jsonData)
            if let jsonArray = json.array {
                for jsonMessage in jsonArray {
                    var sentiment: BinarySentiment
                    if jsonMessage["sentiment"].stringValue == "Positive" {
                        sentiment = .Positive
                    } else {
                        sentiment = .Negative
                    }
                    let rowid = jsonMessage["rowid"].int64Value
                    labels[rowid] = sentiment
                }
            }
        } catch {
            print("Failed to read \(inputFilename). Error: \(error.localizedDescription)")
        }
        return labels
    }
}
