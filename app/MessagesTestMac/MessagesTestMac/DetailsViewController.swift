//
//  DetailsViewController.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 11/19/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Cocoa

class DetailsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var messageStatistics: MessageStatistics? {
        didSet {
            if messageStatistics != nil {
                messageCountLabel.isHidden = false
            } else {
                messageCountLabel.isHidden = true
            }
            updateDetails()
        }
    }
    var chat: Chat? {
        didSet {
            if chat != nil {
                detailsHeaderLabel.isHidden = false
                detailsHeaderLabel.stringValue = chat!.name
            } else {
                detailsHeaderLabel.isHidden = true
            }
        }
    }
    @IBOutlet weak var detailsHeaderLabel: NSTextField!
    @IBOutlet weak var messageCountLabel: NSTextField!
    @IBOutlet weak var wordSummaryTableView: NSTableView!
    @IBOutlet weak var wordSummaryCountLabel: NSTextField!
    @IBOutlet weak var wordSummaryTypeSegmentedControl: NSSegmentedControl!
    
    private enum WordSummaryType {
        case Word
        case Emoji
        case Invalid
    }
    private var wordSummaryType: WordSummaryType {
        switch wordSummaryTypeSegmentedControl.selectedSegment {
        case 0:
            return .Word
        case 1:
            return .Emoji
        default:
            return .Invalid
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordSummaryTableView.dataSource = self
        wordSummaryTableView.delegate = self
    }
    
    @IBAction func switchWordSummaryType(_ sender: NSSegmentedControl) {
        updateUI()
    }
    
    func updateDetails() {
        
        updateUI()
    }
    
    func updateUI() {
        if messageStatistics != nil {
            let count = messageStatistics!.numberOfMessages
            
            var positiveNegativeText = ""
            if messageStatistics!.numberOfPositiveMessages != nil && messageStatistics!.numberOfPositiveMessages != nil {
                let positivePercentage = messageStatistics!.numberOfPositiveMessages! * 100 / count
                let negativePercentage = messageStatistics!.numberOfNegativeMessages! * 100 / count
                let neutralPercentage = messageStatistics!.numberOfNeutralMessages! * 100 / count
                positiveNegativeText = " (\(positivePercentage)% positive, \(negativePercentage)% negative, \(neutralPercentage)% neutral)"
            }
            
            messageCountLabel.stringValue = "\(count) message\(count == 1 ? "" : "s")\(positiveNegativeText)"
            if wordSummaryType == .Word {
                wordSummaryCountLabel.stringValue = "\(messageStatistics!.numberOfWords) Word\(messageStatistics!.numberOfWords == 1 ? "" : "s")"
            } else if wordSummaryType == .Emoji {
                wordSummaryCountLabel.stringValue = "\(messageStatistics!.numberOfEmojis) Emoji\(messageStatistics!.numberOfEmojis == 1 ? "" : "s")"
            }
        }
        wordSummaryTableView.reloadData()
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard messageStatistics != nil else {
            return 0
        }
        if wordSummaryType == .Word {
            return messageStatistics!.wordCounts.count
        } else if wordSummaryType == .Emoji {
            return messageStatistics!.emojiCounts.count
        } else {
            return 0
        }
    }
    
    // MARK: - NSTableViewDelegate
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == wordSummaryTableView && messageStatistics != nil {
            let wordTextCellIdentifier = "WordTextCell"
            let wordCountCellIdentifier = "WordCountCell"
            if tableColumn == wordSummaryTableView.tableColumns[0] {
                if let cell = tableView.make(withIdentifier: wordTextCellIdentifier, owner: nil) as? NSTableCellView {
                    if wordSummaryType == .Word {
                        cell.textField?.stringValue = messageStatistics!.wordCounts[row].word
                    } else if wordSummaryType == .Emoji {
                        cell.textField?.stringValue = messageStatistics!.emojiCounts[row].emoji
                    }
                    return cell
                }
            } else if tableColumn == wordSummaryTableView.tableColumns[1] {
                if let cell = tableView.make(withIdentifier: wordCountCellIdentifier, owner: nil) as? NSTableCellView {
                    if wordSummaryType == .Word {
                        cell.textField?.stringValue = "\(messageStatistics!.wordCounts[row].count)"
                    } else if wordSummaryType == .Emoji {
                        cell.textField?.stringValue = "\(messageStatistics!.emojiCounts[row].count)"
                    }
                    return cell
                }
            }
        }
        return nil
    }
}
