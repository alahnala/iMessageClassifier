//
//  PythonPathViewController.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 12/14/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Cocoa

class PythonPathViewController: NSViewController {
    
    @IBOutlet weak var pathTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pathTextField.stringValue = PythonScriptHelper.pythonPath
    }
    
    @IBAction func cancel(_ sender: NSButton) {
        self.presenting?.dismissViewController(self)
    }
    @IBAction func set(_ sender: NSButton) {
        PythonScriptHelper.pythonPath = self.pathTextField.stringValue
        self.presenting?.dismissViewController(self)
    }
}
