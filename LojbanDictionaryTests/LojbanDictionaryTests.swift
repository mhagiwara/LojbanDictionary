//
//  LojbanDictionaryTests.swift
//  LojbanDictionaryTests
//
//  Created by Masato Hagiwara on 3/6/17.
//  Copyright © 2017 Masato Hagiwara. All rights reserved.
//

import XCTest
@testable import LojbanDictionary

class LojbanDictionaryTests: XCTestCase {
    
    
    func testDictionaryModel() {
        
        // Test DictionaryEntry
        var entry = DictionaryEntry(json: ["foo": "bar"])
        XCTAssert(entry == nil)
        
        entry = DictionaryEntry(json: ["word": 1])
        XCTAssert(entry == nil)
        
        entry = DictionaryEntry(json:
            ["word": "a", "selmaho": "A"])
        XCTAssert(entry!.word == "a")
        XCTAssert(entry!.selmaho == "A")

        entry = DictionaryEntry(json:
            ["word": "a", "selmaho": 1])
        XCTAssert(entry!.word == "a")
        XCTAssert(entry!.selmaho == nil)
        
        // Test DictionaryModel
        var dict = DictionaryModel(json: [
            "a": ["word": "a"],
            "b": ["word": "b"],
            "x": ["foo", "bar"]
            ])
        
        XCTAssert(2 == dict.count())
    }
}
