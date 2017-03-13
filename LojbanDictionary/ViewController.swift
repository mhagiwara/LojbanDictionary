//
//  ViewController.swift
//  LojbanDictionary
//
//  Created by Masato Hagiwara on 3/6/17.
//  Copyright © 2017 Masato Hagiwara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var queryTextField: UITextField!
    
    var dictModel = DictionaryModel()
    
    func loadDictionary() {
        guard let path = Bundle.main.path(forResource: "cmavo", ofType: "json") else {
            return
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data) as! [String: Any] else {
            return
        }
        
        self.dictModel = DictionaryModel(json: json)
        queryTextField.addTarget(self, action: #selector(ViewController.queryChanged(_:)), for: .editingChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDictionary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func queryChanged(_ sender: Any) {
        guard let queryText = self.queryTextField.text else {
            return
        }
        NSLog("Query changed: \(queryText)")
        self.dictModel.search(query: queryText)
    }

}

