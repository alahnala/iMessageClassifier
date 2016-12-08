//
//  MessageTableCell.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 11/19/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Cocoa

class MessageTableCell: NSTableCellView {

    @IBOutlet weak var dateTextField: NSTextField!
    @IBOutlet weak var messageTextField: NSTextField!
    @IBOutlet weak var colorLabel: NSTextField!
    
    var sentimentColor: NSColor? {
        get {
            return colorLabel.textColor
        }
        set(newColor) {
            colorLabel.textColor = newColor
        }
    }
}
