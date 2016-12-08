//
//  ViewController.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 10/18/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Cocoa
import GRDB

class Handle: Record {
    var rowID: Int64?
    var id: String
    var country: String?
    var service: String
    var uncanonicalized_id: String?
    
    /// The table name
    override class var databaseTableName: String {
        return "handle"
    }
    
    /// Initialize from a database row
    required init(row: Row) {
        rowID = row.value(named: "rowid")
        id = row.value(named: "id")
        country = row.value(named: "country")
        service = row.value(named: "service")
        uncanonicalized_id = row.value(named: "uncanonicalized_id")
        super.init(row: row)
    }
    
    
    /// The values persisted in the database
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return [
            "rowid": rowID,
            "id": id,
            "country": country,
            "service": service,
            "uncanonicalized_id": uncanonicalized_id
        ]
    }
    
    /// Update record ID after a successful insertion
    override func didInsert(with rowID: Int64, for column: String?) {
        self.rowID = rowID
    }
    
    var name: String {
        return ContactsManager.sharedManager.findNameFor(phoneNumber: self.id) ?? self.id
    }
}


class Chat: Record {
    var rowID: Int64?
    var displayName: String?
    var handles: [Handle]
    
    /// The table name
    override class var databaseTableName: String {
        return "chat"
    }
    
    /// Initialize from a database row
    required init(row: Row) {
        rowID = row.value(named: "rowid")
        displayName = row.value(named: "display_name")
        handles = [Handle]()
        super.init(row: row)
    }
    
    
    /// The values persisted in the database
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return [
            "rowid": rowID,
            "displayName": displayName
        ]
    }
    
    /// Update record ID after a successful insertion
    override func didInsert(with rowID: Int64, for column: String?) {
        self.rowID = rowID
    }
    
    var name: String {
        var chatName = "\(self.rowID!)"
        if let displayName = self.displayName, displayName.characters.count > 0 {
            chatName = displayName
        } else {
            chatName = self.handles.map({ $0.name }).joined(separator: ", ")
        }
        return chatName
    }
}

class Message: Record {
    var rowID: Int64?
    var guid: String
    var text: String?
    var handleID: Int64?
    var date: Date
    var isFromMe: Bool
    var sentiment: BinarySentiment?
    
    /// The table name
    override class var databaseTableName: String {
        return "handle"
    }
    
    /// Initialize from a database row
    required init(row: Row) {
        rowID = row.value(named: "rowid")
        guid = row.value(named: "guid")
        text = row.value(named: "text")
        handleID = row.value(named: "handle_id")
        isFromMe = row.value(named: "is_from_me")
        let integer = (row.value(named: "date") as! Int64)
        let timeInterval = TimeInterval(integer)
        date = Date(timeIntervalSinceReferenceDate: timeInterval)
        super.init(row: row)
    }
    
    
    /// The values persisted in the database
    override var persistentDictionary: [String: DatabaseValueConvertible?] {
        return [
            "rowid": rowID,
            "guid": guid,
            "text": text,
            "handle_id": handleID,
            "date": date.timeIntervalSinceReferenceDate,
            "is_from_me": isFromMe
        ]
    }
    
    /// Update record ID after a successful insertion
    override func didInsert(with rowID: Int64, for column: String?) {
        self.rowID = rowID
    }
    
    /// Dictionary for writing JSON
    var dictionaryForJSON: Dictionary<String, NSObject> {
        get {
            return [
                "rowID": NSNumber(value: self.rowID!),
                "guid": self.guid as NSString,
                "text": (self.text ?? "") as NSString,
                "handleID": NSNumber(value: self.handleID!),
                "date": self.date.timeIntervalSinceReferenceDate as NSNumber,
                "isFromMe": NSNumber(value: self.isFromMe)
            ]
        }
    }
}

class MainSplitViewController: NSSplitViewController {
    
    var handles = [Handle]() {
        didSet {
//            conversationsViewController.handles = handles
        }
    }
    var chats = [Chat]() {
        didSet {
            conversationsViewController.chats = chats
        }
    }
    var messages = [Message]() {
        didSet {
            messagesListViewController.messages = messages
        }
    }
    var dbQueue: DatabaseQueue!
    
    var messagesListViewController: MessagesListViewController {
        get {
            return splitViewItems[1].viewController as! MessagesListViewController
        }
    }
    var conversationsViewController: ConversationsViewController {
        get {
            return splitViewItems[0].viewController as! ConversationsViewController
        }
    }
    var detailsViewController: DetailsViewController {
        get {
            return splitViewItems[2].viewController as! DetailsViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        conversationsViewController.delegate = self
        
        var config = Configuration()
        config.readonly = true
        config.trace = { print($0) }
        do {
            let homeDirectory = NSHomeDirectory()
            dbQueue = try DatabaseQueue(path: "\(homeDirectory)/Desktop/chat.db", configuration: config)
            
//            handles = dbQueue.inDatabase { db in
//                Handle.fetchAll(db, "SELECT * FROM handle")
//            }
            chats = dbQueue.inDatabase { db in
                Chat.fetchAll(db, "SELECT * FROM chat")
            }
            for chat in chats {
                chat.handles = dbQueue.inDatabase { db in
                    Handle.fetchAll(db, "SELECT * FROM handle H WHERE H.ROWID in (SELECT handle_id from chat_handle_join B WHERE B.chat_id = ?)", arguments: [chat.rowID])
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    @IBAction func searchMessages(sender: NSSearchField) {
        print(sender.stringValue)
    }

    
    func messagesFor(handle: Handle) -> [Message] {
        let fetchedMessages = dbQueue.inDatabase { db in
            Message.fetchAll(db, "SELECT * FROM message WHERE handle_id = ?", arguments: [handle.rowID])
        }
        return fetchedMessages
    }
    func messagesFor(chat: Chat) -> [Message] {
        let fetchedMessages = dbQueue.inDatabase { db in
            Message.fetchAll(db, "SELECT * FROM message M WHERE M.ROWID in (SELECT message_id from chat_message_join B WHERE B.chat_id = ?)", arguments: [chat.rowID])
        }
        return fetchedMessages
    }
    
    func searchMessages(query: String) {
        self.messagesListViewController.query = query
    }
    
    func labelSentimentInMessages(labels: [Int64: BinarySentiment]) {
        var positiveCount = 0
        var negativeCount = 0
        for message in self.messages {
            if let rowid = message.rowID {
                if let sentiment = labels[rowid] {
                    message.sentiment = sentiment
                    if sentiment == .Positive {
                        positiveCount += 1
                    } else {
                        negativeCount += 1
                    }
                }
            }
        }
        self.messagesListViewController.didUpdateSenetimentLabels()
        self.detailsViewController.messageStatistics?.numberOfPositiveMessages = positiveCount
        self.detailsViewController.messageStatistics?.numberOfNegativeMessages = negativeCount
        self.detailsViewController.updateDetails()
    }
}

enum BinarySentiment {
    case Positive
    case Negative
}

extension MainSplitViewController: ConversationsViewControllerDelegate {
    func conversationsViewController(viewController: ConversationsViewController, didSelectChat chat: Chat) {
        self.messages = messagesFor(chat: chat)
        self.messagesListViewController.chat = chat
        self.detailsViewController.messageStatistics = MessageStatistics(messages: self.messages)
        self.detailsViewController.chat = chat
        
        let pythonHelper = PythonScriptHelper()
        let messagesAsJSONArray = self.messages.map { message in
            return message.dictionaryForJSON
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            pythonHelper.saveToFile(data: messagesAsJSONArray)
            pythonHelper.runScript { output in
                if output != nil {
                    print(output!)
                    let sentimentLabels = pythonHelper.getLabels()
                    DispatchQueue.main.async {
                        self.labelSentimentInMessages(labels: sentimentLabels)
                    }
                } else {
                    print("error running script")
                }
            }
        }
    }
}

/*
extension MainSplitViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == handlesTableView {
            return handles.count
        } else if tableView == messagesTableView {
            return messages.count
        } else if tableView == wordCountTableView {
            return wordCounts.count
        } else if tableView == emojiCountTableView {
            return emojiCounts.count
        }
        return 0
    }
}

extension MainSplitViewController : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == handlesTableView {
            let cellIdentifier = "HandleCell"
            if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = handles[row].id
                return cell
            }
        } else if tableView == messagesTableView {
            let messageCellIdentifier = "MessageCell"
            let dateCellIdentifier = "DateCell"
            let message = messages[row]
            if tableColumn == messagesTableView.tableColumns[0] {
                if let cell = tableView.make(withIdentifier: dateCellIdentifier, owner: nil) as? NSTableCellView {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .medium
                    cell.textField?.stringValue = dateFormatter.string(from: message.date)
                    return cell
                }
            } else if tableColumn == messagesTableView.tableColumns[1] {
                if let cell = tableView.make(withIdentifier: messageCellIdentifier, owner: nil) as? NSTableCellView {
                    cell.textField?.stringValue = message.text ?? ""
                    return cell
                }
            }
        } else if tableView == wordCountTableView {
            let wordCellIdentifier = "WordCell"
            let countCellIdentifier = "CountCell"
            if tableColumn == wordCountTableView.tableColumns[0] {
                if let cell = tableView.make(withIdentifier: wordCellIdentifier, owner: nil) as? NSTableCellView {
                    cell.textField?.stringValue = wordCounts[row].word
                    return cell
                }
            } else if tableColumn == wordCountTableView.tableColumns[1] {
                if let cell = tableView.make(withIdentifier: countCellIdentifier, owner: nil) as? NSTableCellView {
                    cell.textField?.stringValue = "\(wordCounts[row].count)"
                    return cell
                }
            }
        } else if tableView == emojiCountTableView {
            let emojiCellIdentifier = "EmojiCell"
            let countCellIdentifier = "CountCell"
            if tableColumn == emojiCountTableView.tableColumns[0] {
                if let cell = tableView.make(withIdentifier: emojiCellIdentifier, owner: nil) as? NSTableCellView {
                    cell.textField?.stringValue = emojiCounts[row].emoji
                    return cell
                }
            } else if tableColumn == emojiCountTableView.tableColumns[1] {
                if let cell = tableView.make(withIdentifier: countCellIdentifier, owner: nil) as? NSTableCellView {
                    cell.textField?.stringValue = "\(emojiCounts[row].count)"
                    return cell
                }
            }
        }
        return nil
    }
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let tableView = notification.object as? NSTableView {
            if tableView == handlesTableView {
                updateMessagesForSelectedHandle()
            }
        }
    }
}
*/


// thanks to http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
        0x1D000 ... 0x1F77F, // Emoticons
        0x2100 ... 0x27BF, // Misc symbols and Dingbats
        0xFE00 ... 0xFE0F, // Variation Selectors:
        0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}

// thanks to http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
extension String {
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return unicodeScalars.map { $0 }.filter { $0.isEmoji }.count != 0
    }
    
    var containsOnlyEmoji: Bool {
        
        return characters.count > 0 && characters.count == unicodeScalars.map { $0 }.filter { $0.isEmoji }.count
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar , !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) } .filter { $0.characters.count > 0 }
    }
    
    private var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous , previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
}

