//
//  DictionaryEntryViewController.swift
//  LojbanDictionary
//
//  Created by Masato Hagiwara on 4/3/17.
//  Copyright © 2017 Masato Hagiwara. All rights reserved.
//

import UIKit

class DictionaryEntryViewController: UIViewController {
  
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var selmahoLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var wordTypeImage: UIImageView!
    @IBOutlet weak var wordTypeLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!

    var entry: DictionaryEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.entry != nil) {
            wordLabel.text = entry!.word
            selmahoLabel.text = entry!.selmaho
            englishLabel.text = entry!.english
            definitionLabel.text = entry!.definition
            definitionLabel.sizeToFit()
            notesLabel.text = entry!.notes
            notesLabel.sizeToFit()
            wordTypeImage.image = entry!.typeImage
            wordTypeLabel.text = entry!.typeLabel
            creditLabel.text = entry!.typeCredit
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
