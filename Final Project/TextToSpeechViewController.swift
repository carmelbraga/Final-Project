//
//  TextToSpeechViewController.swift
//  Final Project
//
//  Created by Carmel Braga on 5/7/20.
//  Copyright © 2020 Carmel Braga. All rights reserved.
//

import UIKit
import AVFoundation

class TextToSpeechViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var languagePicker: UIPickerView!
    
    var languageSelected: String = ""
    var languages:[(name: String, code: String)] = [("English", "en-US"), ("Portuguese", "pt-BR"), ("Spanish", "es"), ("Arabic", "ar"), ("Norwegian", "nb"), ("Chinese", "zh"), ("Croatian", "hr"), ("Czech", "cs"), ("Danish", "da"), ("Dutch", "nl"), ("Finnish", "fin"), ("French", "fr"), ("German", "de"), ("Greek", "gre"), ("Hebrew", "heb"), ("Hindi", "hin"), ("Indonesian", "ind"), ("Italian", "ita"), ("Japanese", "ja"), ("Korean", "kor"), ("Malay", "ms"), ("Polish", "pol"), ("Russian", "rus"), ("Slovak", "slo"), ("Swedish", "swe"), ("Thai", "tha"), ("Vietnamese", "vie")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextView.text = "Type here!"

        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
          }
          
          func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return languages.count
          }
          
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return languages[row].name
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
           
           languageSelected = String(languages[row].code)
           print(languageSelected)
       
       }
       
    @IBAction func play(_ sender: Any) {
        let input: String! = inputTextView.text
        utterance = AVSpeechUtterance(string: input)
        utterance.voice = AVSpeechSynthesisVoice(language: languageSelected)
        synthesizer.speak(utterance)
        synthesizer.continueSpeaking()
    }
    
    @IBAction func clear(_ sender: Any) {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
               inputTextView.text = ""
    }
    
    @IBAction func stop(_ sender: Any) {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    @IBAction func pause(_ sender: Any) {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
    }
    
}
