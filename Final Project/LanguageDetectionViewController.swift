//
//  LanguageDetectionViewController.swift
//  Final Project
//
//  Created by Carmel Braga on 5/7/20.
//  Copyright © 2020 Carmel Braga. All rights reserved.
//

import UIKit

class LanguageDetectionViewController: UIViewController {

    @IBOutlet weak var detectionTextView: UITextView!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detectionTextView.text = "Type here!"

    }
    
    @IBAction func detect(_ sender: Any) {
        let input = detectionTextView.text!

        if let code = NSLinguisticTagger.dominantLanguage(for: input) {
              
            let locale = NSLocale(localeIdentifier: code)
            let language = locale.displayName(forKey: NSLocale.Key.identifier, value: code)!
            languageLabel.text = "Language: " + language
            
               } else {
                    languageLabel.text = "Language: Unknow"
               }
    }
}
