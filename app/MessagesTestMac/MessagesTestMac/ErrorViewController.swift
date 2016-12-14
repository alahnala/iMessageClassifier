//
//  ErrorViewController.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 12/14/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Cocoa

class ErrorViewController: NSViewController {
    
    @IBOutlet weak var errorLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func close(_ sender: NSButton) {
        self.presenting?.dismissViewController(self)
    }
}
