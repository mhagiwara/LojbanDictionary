//
//  DictionaryModel.swift
//  LojbanDictionary
//
//  Created by Masato Hagiwara on 3/7/17.
//  Copyright © 2017 Masato Hagiwara. All rights reserved.
//

import UIKit

class DictionaryEntry: NSObject {
    
    let word: String
    
    let selmaho: String?
    
    init?(json: [String: Any]) {
        
        // Initialize DictionaryEntry from a JSON object.
        
        // "word" is a mandatory key - return nil if not found (or other type)
        guard let word = json["word"] as? String else {
            return nil
        }
        
        self.word = word
        self.selmaho = json["selmaho"] as? String
    }
}

class DictionaryModel: NSObject {

    var entries = [DictionaryEntry]()
    
    init(json: [String: Any]) {

        // Initialize DictionaryModel from a JSON object.
        for entryJson in json.values {
            guard let entryJsonAsDict = entryJson as? [String: Any] else {
                continue
            }

            guard let entry = DictionaryEntry(json: entryJsonAsDict) else {
                continue
            }
            
            self.entries.append(entry)
        }
    }
    
    func count() -> Int {
        // Returns the number of entries currently in the dict.
        return self.entries.count
    }
}
