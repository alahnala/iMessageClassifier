//
//  MainWindowController.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 11/23/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    var mainSplitViewController: MainSplitViewController {
        return self.contentViewController as! MainSplitViewController
    }
    
    @IBAction func selectChatDatabase(_ sender: NSButton) {
        let defaultDatabasePath = MainSplitViewController.defaultDatabasePath
        
        let dialog = NSOpenPanel()
        dialog.message = "Choose iMessage database"
        if let defaultURL = URL(string: defaultDatabasePath)?.deletingLastPathComponent() {
            dialog.directoryURL = defaultURL
        }
        dialog.showsHiddenFiles = true
        dialog.showsResizeIndicator = true
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["db"]
        if (dialog.runModal() == NSModalResponseOK) {
            if let result = dialog.url {
                let path = result.path
                self.mainSplitViewController.databasePath = path
            }
        }
    }

    @IBAction func searchMessages(_ sender: NSSearchField) {
        mainSplitViewController.searchMessages(query: sender.stringValue)
    }
}
