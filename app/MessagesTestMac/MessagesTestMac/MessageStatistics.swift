//
//  MessageStatistics.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 11/23/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Foundation

class MessageStatistics {
    let numberOfMessages: Int
    let numberOfWords: Int
    let numberOfEmojis: Int
    var wordCounts = [(word: String, count: Int)]()
    var emojiCounts = [(emoji: String, count: Int)]()
    
    init(messages: [Message]) {
        numberOfMessages = messages.count
        
        var words = Dictionary<String, Int>()
        var emojis = Dictionary<String, Int>()
        var wordCount = 0
        var emojiCount = 0
        for message in messages {
            if message.text != nil {
                let wordsInMessage = message.text!.components(separatedBy: NSCharacterSet.whitespaces)
                for word in wordsInMessage {
                    if let count = words[word] {
                        words[word] = count + 1
                    } else {
                        words[word] = 1
                    }
                    wordCount += 1
                }
                
                for emoji in message.text!.emojis {
                    if let count = emojis[emoji] {
                        emojis[emoji] = count + 1
                    } else {
                        emojis[emoji] = 1
                    }
                    emojiCount += 1
                }
            }
        }
        numberOfWords = wordCount
        numberOfEmojis = emojiCount
        let sortedWords = words.sorted { $0.value > $1.value }
        wordCounts = Array(sortedWords.prefix(100)) as! [(word: String, count: Int)]
        let sortedEmojis = emojis.sorted { $0.value > $1.value }
        emojiCounts = Array(sortedEmojis.prefix(20)) as! [(emoji: String, count: Int)]
    }
}
