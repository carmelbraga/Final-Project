//
//  SpeechToTextViewController.swift
//  Final Project
//
//  Created by Carmel Braga on 5/7/20.
//  Copyright © 2020 Carmel Braga. All rights reserved.
//

import UIKit
import Speech

class SpeechToTextViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, SFSpeechRecognizerDelegate {

    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var microphone: UIButton!
    @IBOutlet weak var speechTextView: UITextView!
    
    var recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    var languageSelected: String = ""
    var languages:[(name: String, code: String)] = [("English", "en-US"), ("Portuguese", "pt-BR"), ("Spanish", "es"), ("Arabic", "ar"), ("Norwegian", "nb"), ("Chinese", "zh"), ("Croatian", "hr"), ("Czech", "cs"), ("Danish", "da"), ("Dutch", "nl"), ("Finnish", "fin"), ("French", "fr"), ("German", "de"), ("Greek", "gre"), ("Hebrew", "heb"), ("Hindi", "hin"), ("Indonesian", "ind"), ("Italian", "ita"), ("Japanese", "ja"), ("Korean", "kor"), ("Malay", "ms"), ("Polish", "pol"), ("Russian", "rus"), ("Slovak", "slo"), ("Swedish", "swe"), ("Thai", "tha"), ("Vietnamese", "vie")]

    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let engine = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.languagePicker.delegate = self
        self.languagePicker.dataSource = self
        
        speechTextView.text = "Talk to me!"
               
               microphone.isEnabled = false
                  
               //recognizer!.delegate = self
                  
                  SFSpeechRecognizer.requestAuthorization { (authStatus) in
                      
                      var isButtonEnabled = false
                      
                      switch authStatus {
                      case .authorized:
                          isButtonEnabled = true
                          
                      case .denied:
                          isButtonEnabled = false
                          print("Access denied.")
                          
                      case .restricted:
                          isButtonEnabled = false
                          print("Access restricted.")
                          
                      case .notDetermined:
                          isButtonEnabled = false
                          print("Access not authorized.")
                      @unknown default:
                       fatalError()
                   }
                      
                      OperationQueue.main.addOperation() {
                          self.microphone.isEnabled = isButtonEnabled
                      }
                  }

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
        recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: languageSelected))!
        print(languageSelected)
    
    }
    
    @IBAction func transcribe(_ sender: Any) {
        if engine.isRunning {
                      engine.stop()
                      request?.endAudio()
                      microphone.isEnabled = false
                      microphone.setTitle("Transcribe", for: .normal)
                  } else {
                      record()
                      microphone.setTitle("Stop", for: .normal)
                  }
    }
    
    func record() {
           
           if task != nil {
               task?.cancel()
               task = nil
           }
           
           let session = AVAudioSession.sharedInstance()
           do {
               try session.setCategory(AVAudioSession.Category.record)
               try session.setMode(AVAudioSession.Mode.measurement)
               try session.setActive(true, options: .notifyOthersOnDeactivation)
           } catch {
               print("Property error.")
           }
           
           request = SFSpeechAudioBufferRecognitionRequest()
           
           let input = engine.inputNode
           
           guard let request = request else {
               fatalError("Unable to create request.")
           }
           
           request.shouldReportPartialResults = true
           
           task = recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
               
               var isFinal = false
               
               if result != nil {
                   
                   self.speechTextView.text = result?.bestTranscription.formattedString
                   isFinal = (result?.isFinal)!
               }
               
               if error != nil || isFinal {
                   self.engine.stop()
                   input.removeTap(onBus: 0)
                   
                   self.request = nil
                   self.task = nil
                   
                   self.microphone.isEnabled = true
               }
           })
           
           let format = input.outputFormat(forBus: 0)
           input.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, when) in
               self.request?.append(buffer)
           }
           
           engine.prepare()
           
           do {
               try engine.start()
           } catch {
               print("Engine error.")
           }
           
           speechTextView.text = "Talk to me!"
           
       }
       
       func speechRecognizer(_ recognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
           if available {
               microphone.isEnabled = true
           } else {
               microphone.isEnabled = false
           }
       }
}
