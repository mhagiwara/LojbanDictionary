//
//  ViewController.swift
//  LojbanDictionary
//
//  Created by Masato Hagiwara on 3/6/17.
//  Copyright © 2017 Masato Hagiwara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "cmavo", ofType: "json") else {
            return
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data) as! [String: Any] {
            NSLog("\(json["a"])")
        } else {
            return
        }

        // NSLog("\(json)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

