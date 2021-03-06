//
//  DictionaryModel.swift
//  LojbanDictionary
//
//  Created by Masato Hagiwara on 3/7/17.
//  Copyright © 2017 Masato Hagiwara. All rights reserved.
//

import UIKit

enum WordType {
    case cmavo
    case gismu
    case lujvo
    case fuhivla
}

class DictionaryEntry: NSObject {
    
    let type: WordType?
    let word: String
    let english: String

    let selmaho: String?
    let definition: String?
    let notes: String?
    
    var typeImage: UIImage? {
        switch type {
        case .cmavo?:
            return UIImage(named: "img-cmavo.png")
        case .gismu?:
            return UIImage(named: "img-gismu.png")
        case .lujvo?:
            return UIImage(named: "img-lujvo.png")
        case .fuhivla?:
            return UIImage(named: "img-fuhivla.png")
        default:
            return nil
        }
    }
    
    var typeLabel: String? {
        switch type {
        case .cmavo?:
            return "cmavo"
        case .gismu?:
            return "gismu"
        case .lujvo?:
            return "lujvo"
        case .fuhivla?:
            return "fu'ivla"
        default:
            return nil
        }
    }
    
    var typeCredit: String? {
        switch type {
        case .cmavo?:
            return "Icon image by Nikita Golubev (FLATICON)"
        case .gismu?:
            return "Icon image by Prosymbols (FLATICON)"
        case .lujvo?:
            return "Icon image by Prosymbols (FLATICON)"
        case .fuhivla?:
            return "Icon image by Freepik (FLATICON)"
        default:
            return nil
        }
    }
    
    convenience init?(json: [String: Any]) {
        self.init(json: json, type: nil)
    }
    
    init?(json: [String: Any], type: WordType?) {
        
        // Initialize DictionaryEntry from a JSON object.
        
        // "word" is a mandatory key - return nil if not found (or other type)
        guard let word = json["word"] as? String else {
            return nil
        }
        
        // "english" is also a mandatory key
        guard let english = json["english"] as? String else {
            return nil
        }
        
        self.word = word
        self.english = english
        self.selmaho = json["selmaho"] as? String
        self.definition = json["definition"] as? String
        self.notes = json["notes"] as? String
        self.type = type
    }
    
    override public var description: String {
        return "DictionaryEntry(word: \"\(self.word)\", english: \"\(self.english)\")"
    }
}

class DictionaryModel: NSObject {

    var entries = [DictionaryEntry]()
    
    static func levenshtein(aStr: String, bStr: String) -> Int {
        let a = Array(aStr.characters)
        let b = Array(bStr.characters)

        var dist = [[Int]]()
        for _ in 0...a.count {
            dist.append([Int](repeating: 0, count: b.count + 1))
        }
        
        for i in 1...a.count {
            dist[i][0] = i
        }
        
        for j in 1...b.count {
            dist[0][j] = j
        }
        
        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i][j] = dist[i-1][j-1]
                } else {
                    dist[i][j] = min(
                        dist[i-1][j] + 1,
                        dist[i][j-1] + 1,
                        dist[i-1][j-1] + 1
                    )
                }
            }
        }
        
        return dist[a.count][b.count]
    }
    
    func loadJson(json: [String: Any], type: WordType?) {
        // Load dictionary entries from json with type
        for entryJson in json.values {
            guard let entryJsonAsDict = entryJson as? [String: Any] else {
                continue
            }
            
            guard let entry = DictionaryEntry(json: entryJsonAsDict, type: type) else {
                continue
            }
            
            self.entries.append(entry)
        }
    }
    
    func loadJson(json: [String: Any]) {
        loadJson(json: json, type: nil)
    }
    
    override init() {
        // Initialize an empty DictionaryModel
        super.init()
    }
    
    func count() -> Int {
        // Returns the number of entries currently in the dict.
        return self.entries.count
    }
    
    func search(query: String) -> [DictionaryEntry:Int] {
        // Search entries by query, and returns matched entries and their scores.
        
        var entryScores = [DictionaryEntry:Int]()
        
        for entry in self.entries {
            var score = 0
            if let wordRange = entry.word.range(of: query) {
                score += 10

                // extra points if starts with the word
                if (entry.word.startIndex == wordRange.lowerBound) {
                    score += 10
                }
                
                // reward points based on edit distance
                let editDist = DictionaryModel.levenshtein(aStr: query, bStr: entry.word)
                score += 10 - editDist
            }
            
            let englishRange = entry.english.range(of: query)
            if (englishRange != nil) {
                score += 10
            }
            
            if (score > 0) {
                entryScores[entry] = score
            }
        }
        return entryScores
    }
    
    func topN(query: String, n: Int) -> [DictionaryEntry] {
        // Search entries by query, and returns a ranked top N list of entries.
        
        let entryScores = self.search(query: query)
        if (entryScores.count > 0) {
            let sortedEntries: [DictionaryEntry] = Array(entryScores.keys.sorted(by: {entryScores[$0]! > entryScores[$1]!})[0..<min(n, entryScores.count)])
            return sortedEntries
        } else {
            return [DictionaryEntry]()
        }
    }
}
