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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowEntry") {
            let entryVC = segue.destination as! DictionaryEntryViewController
            entryVC.entry = (sender as! DictionaryEntry)
        }
    }
    
    // DictionaryModel used for search
    var dictModel = DictionaryModel()
    // Current search result (topN entries)
    var entries = [DictionaryEntry]()
    
    func getJsonWithName(resourceName: String) -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data) as! [String: Any] else {
            return nil
        }
        return json
    }
    
    func loadDictionary() {
        dictModel = DictionaryModel()
        if let cmavoJson = getJsonWithName(resourceName: "cmavo") {
            dictModel.loadJson(json: cmavoJson, type: .cmavo)
        }
        if let gismuJson = getJsonWithName(resourceName: "gismu") {
            dictModel.loadJson(json: gismuJson, type: .gismu)
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowEntry", sender: entries[indexPath.row])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let currentEntry = entries[indexPath.row]
        cell.textLabel?.text = currentEntry.word
        cell.detailTextLabel?.text = currentEntry.english
        if (currentEntry.type == .gismu) {
            cell.imageView?.image = UIImage(named: "img-gismu.png")
            cell.imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } else if (currentEntry.type == .cmavo) {
            cell.imageView?.image = UIImage(named: "img-cmavo.png")
            cell.imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    
        
        return cell
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
}

