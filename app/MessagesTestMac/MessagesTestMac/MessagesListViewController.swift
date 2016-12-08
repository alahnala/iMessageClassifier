//
//  MessagesListViewController.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 11/19/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Cocoa

class MessagesListViewController: NSViewController {

    @IBOutlet weak var messagesTableView: NSTableView!
    
    var messages = [Message]() {
        didSet {
            filterMessages()
        }
    }
    var filteredMessages = [Message]() {
        didSet {
            messagesTableView.reloadData()
        }
    }
    var query = "" {
        didSet {
            filterMessages()
        }
    }
    
    var chat: Chat?
    
    func filterMessages() {
        if query == "" {
            filteredMessages = messages
        } else {
            filteredMessages = messages.filter({ (message) -> Bool in
                return message.text?.lowercased().contains(query.lowercased()) ?? false
            })
        }
    }
    
    func handleFor(rowID: Int64) -> Handle? {
        if chat != nil {
            for handle in chat!.handles {
                if handle.rowID == rowID {
                    return handle
                }
            }
        }
        return nil
    }
    
    func didUpdateSenetimentLabels() {
        self.messagesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    }
    
}

extension MessagesListViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filteredMessages.count
    }
}

extension MessagesListViewController : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == messagesTableView {
            let messageCellIdentifier = "MessageCell"
            let message = filteredMessages[row]
            if tableColumn == messagesTableView.tableColumns[0] {
                if let cell = tableView.make(withIdentifier: messageCellIdentifier, owner: nil) as? MessageTableCell {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .medium
                    var dateText = dateFormatter.string(from: message.date)
                    if message.isFromMe {
                        dateText += " (Me)"
                    } else if message.handleID != nil {
                        if let handle = handleFor(rowID: message.handleID!) {
                            dateText += " (\(handle.name))"
                        }
                    }
                    cell.dateTextField?.stringValue = dateText
                    
                    cell.messageTextField?.stringValue = message.text ?? ""
                    
                    cell.sentimentColor = NSColor.clear
                    if let sentiment = message.sentiment {
                        switch sentiment {
                        case .Positive:
                            cell.sentimentColor = NSColor(red:0.58, green:0.75, blue:0.49, alpha:1.00)
                        case .Negative:
                            cell.sentimentColor = NSColor(red:0.75, green:0.22, blue:0.35, alpha:1.00)
                        }
                    }
                    
                    return cell
                }
            }
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let dateHeight: CGFloat = 14.0
        let stackViewSpacing: CGFloat = 0.0
        let messageTextHeight: CGFloat = filteredMessages[row].text?.displayHeightForWidth(width: 445.0) ?? 0.0
        let extraSpacing: CGFloat = 10.0
        return dateHeight + stackViewSpacing + messageTextHeight + extraSpacing
    }
}

extension String {
    func displayHeightForWidth(width : CGFloat) -> CGFloat {
        let size = NSMakeSize(width, 0)
        let bounds = NSString(string: self).boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading])
        return bounds.size.height
    }
}
