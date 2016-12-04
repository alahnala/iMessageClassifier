//
//  ConversationsViewController.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 11/19/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Cocoa

protocol ConversationsViewControllerDelegate {
    // func conversationsViewController(viewController: ConversationsViewController, didSelectHandle handle: Handle);
    func conversationsViewController(viewController: ConversationsViewController, didSelectChat chat: Chat);
}

class ConversationsViewController: NSViewController {

    @IBOutlet weak var conversationsTableView: NSTableView!
    
    var delegate: ConversationsViewControllerDelegate?
    
    var chats = [Chat]() {
        didSet {
            conversationsTableView.reloadData()
        }
    }
    
//    var handles = [Handle]() {
//        didSet {
//            conversationsTableView.reloadData()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversationsTableView.delegate = self
        conversationsTableView.dataSource = self
    }
    
    func updateMessagesForSelectedHandle() {
        if conversationsTableView.selectedRowIndexes.count == 1 {
            let selectedChat = chats[conversationsTableView.selectedRow]
            self.delegate?.conversationsViewController(viewController: self, didSelectChat: selectedChat)
        }
    }
}

extension ConversationsViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return chats.count
    }
}

extension ConversationsViewController : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == conversationsTableView {
            let cellIdentifier = "HandleCell"
            if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
                let chat = chats[row]
                cell.textField?.stringValue = chat.name
                return cell
            }
        }
        return nil
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let tableView = notification.object as? NSTableView {
            if tableView == conversationsTableView {
                updateMessagesForSelectedHandle()
            }
        }
    }
}
