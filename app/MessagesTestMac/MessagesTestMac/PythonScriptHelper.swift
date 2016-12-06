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
        // inspired by http://stackoverflow.com/questions/28768015/how-to-save-an-array-as-a-json-file-in-swift
        
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("test.json")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: (jsonFilePath?.absoluteString)!, isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: (jsonFilePath?.absoluteString)!, contents: nil, attributes: nil)
            if created {
                print("File created ")
            } else {
                print("Couldn't create file for some reason")
            }
        } else {
            print("File already exists")
        }
        
        // creating JSON out of the above array
        var jsonData: NSData!
        do {
            jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions()) as NSData!
            let jsonString = String(data: jsonData as Data, encoding: String.Encoding.utf8)
            print(jsonString!)
        } catch let error as NSError {
            print("Array to JSON conversion failed: \(error.localizedDescription)")
        }
        
        // Write that JSON to the file created earlier
//        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("test.json")
        do {
            let file = try FileHandle(forWritingTo: jsonFilePath!)
            file.write(jsonData as Data)
            print("JSON data was written to the file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
    func runScript() {
        
    }
}
