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

    @IBAction func searchMessages(_ sender: NSSearchField) {
        mainSplitViewController.searchMessages(query: sender.stringValue)
    }
}
