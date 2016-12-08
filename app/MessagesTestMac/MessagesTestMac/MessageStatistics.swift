//
//  MessageStatistics.swift
//  MessagesTestMac
//
//  Created by Maxim Aleksa on 11/23/16.
//  Copyright © 2016 Maxim Aleksa. All rights reserved.
//

import Foundation

class MessageStatistics {
    
    private static let stopWords = [
        "!!",
        "?!",
        "??",
        "!?",
        "`",
        "``",
        "''",
        "-lrb-",
        "-rrb-",
        "-lsb-",
        "-rsb-",
        ",",
        ".",
        ":",
        ";",
        "\"",
        "'",
        "?",
        "<",
        ">",
        "{",
        "}",
        "[",
        "]",
        "+",
        "-",
        "(",
        ")",
        "&",
        "%",
        "$",
        "@",
        "!",
        "^",
        "#",
        "*",
        "..",
        "...",
        "'ll",
        "'s",
        "'m",
        "a",
        "about",
        "above",
        "after",
        "again",
        "against",
        "all",
        "am",
        "an",
        "and",
        "any",
        "are",
        "aren't",
        "as",
        "at",
        "be",
        "because",
        "been",
        "before",
        "being",
        "below",
        "between",
        "both",
        "but",
        "by",
        "can",
        "can't",
        "cannot",
        "could",
        "couldn't",
        "did",
        "didn't",
        "do",
        "does",
        "doesn't",
        "doing",
        "don't",
        "down",
        "during",
        "each",
        "few",
        "for",
        "from",
        "further",
        "had",
        "hadn't",
        "has",
        "hasn't",
        "have",
        "haven't",
        "having",
        "he",
        "he'd",
        "he'll",
        "he's",
        "her",
        "here",
        "here's",
        "hers",
        "herself",
        "him",
        "himself",
        "his",
        "how",
        "how's",
        "i",
        "i'd",
        "i'll",
        "i'm",
        "i've",
        "if",
        "in",
        "into",
        "is",
        "isn't",
        "it",
        "it's",
        "its",
        "itself",
        "let's",
        "me",
        "more",
        "most",
        "mustn't",
        "my",
        "myself",
        "no",
        "nor",
        "not",
        "of",
        "off",
        "on",
        "once",
        "only",
        "or",
        "other",
        "ought",
        "our",
        "ours ",
        "ourselves",
        "out",
        "over",
        "own",
        "same",
        "shan't",
        "she",
        "she'd",
        "she'll",
        "she's",
        "should",
        "shouldn't",
        "so",
        "some",
        "such",
        "than",
        "that",
        "that's",
        "the",
        "their",
        "theirs",
        "them",
        "themselves",
        "then",
        "there",
        "there's",
        "these",
        "they",
        "they'd",
        "they'll",
        "they're",
        "they've",
        "this",
        "those",
        "through",
        "to",
        "too",
        "under",
        "until",
        "up",
        "very",
        "was",
        "wasn't",
        "we",
        "we'd",
        "we'll",
        "we're",
        "we've",
        "were",
        "weren't",
        "what",
        "what's",
        "when",
        "when's",
        "where",
        "where's",
        "which",
        "while",
        "who",
        "who's",
        "whom",
        "why",
        "why's",
        "with",
        "won't",
        "would",
        "wouldn't",
        "you",
        "you'd",
        "you'll",
        "you're",
        "you've",
        "your",
        "yours",
        "yourself",
        "yourselves",
        "###",
        "return",
        "arent",
        "cant",
        "couldnt",
        "didnt",
        "doesnt",
        "dont",
        "hadnt",
        "hasnt",
        "havent",
        "hes",
        "heres",
        "hows",
        "im",
        "isnt",
        "its",
        "lets",
        "mustnt",
        "shant",
        "shes",
        "shouldnt",
        "thats",
        "theres",
        "theyll",
        "theyre",
        "theyve",
        "wasnt",
        "were",
        "werent",
        "whats",
        "whens",
        "wheres",
        "whos",
        "whys",
        "wont",
        "wouldnt",
        "youd",
        "youll",
        "youre",
        "youve"
    ]
    
    let numberOfMessages: Int
    var numberOfPositiveMessages: Int?
    var numberOfNegativeMessages: Int?
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
                    if !MessageStatistics.stopWords.contains(word.lowercased()) && word.characters.count > 0 {
                        if let count = words[word] {
                            words[word] = count + 1
                        } else {
                            words[word] = 1
                        }
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
