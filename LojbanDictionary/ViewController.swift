//
//  ViewController.swift
//  LojbanDictionary
//
//  Created by Masato Hagiwara on 3/6/17.
//  Copyright © 2017 Masato Hagiwara. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    let cellIdentifier = "Cell";
    
    // DictionaryModel used for search
    var dictModel = DictionaryModel()
    // Current search result (topN entries)
    var entries = [DictionaryEntry]()
    
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

    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
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
        entries = dictModel.topN(query: queryText, n: 30)
        NSLog("Number of results: \(entries.count)")
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let currentEntry = entries[indexPath.row]
        cell.textLabel?.text = currentEntry.word
        cell.detailTextLabel?.text = currentEntry.english
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
}

