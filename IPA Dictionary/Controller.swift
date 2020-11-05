//
//  Controller.swift
//  IPA Dictionary
//
//  Created by Szymon Łopaciuk on 2020-11-05.
//  Copyright © 2020 lopaciuk. All rights reserved.
//

import Cocoa

class Controller: NSObject {
    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var ipaField: NSTextField!
    @IBOutlet var progressIndicator: NSProgressIndicator!
    @IBOutlet var languageSelector: NSPopUpButton!
    
    var activeLanguage = "fr_FR"
    
    override func awakeFromNib() {
        languageSelector.addItems(withTitles: Model.availableLanguages())
        languageSelector.selectItem(withTitle: Model.languageCodeToName[activeLanguage]!)
    }
    
    @IBAction func changeLanguage(sender: NSPopUpButton) {
        activeLanguage = Model.languageNameToCode[sender.titleOfSelectedItem!]!
        startWaitingDisplay()
        DispatchQueue.global(qos: .background).async {
            let _ = Model.instance(for: self.activeLanguage)
            DispatchQueue.main.async {
                self.performSearch(sender: self)
            }
        }
    }
    
    @IBAction func performSearch(sender: NSObject) {
        let spelling = self.searchField.stringValue
        startWaitingDisplay()
        DispatchQueue.global(qos: .background).async {
            let result = Model.instance(for: self.activeLanguage).ipaFor(spelling: spelling)
            DispatchQueue.main.async {
                self.ipaField.stringValue = result ?? ""
                self.stopWaitingDisplay()
            }
        }
    }
    
    func startWaitingDisplay() {
        ipaField.placeholderString = "/plˈiːz wˈe‍ɪt/"
        progressIndicator.startAnimation(self)
    }
    
    func stopWaitingDisplay() {
        if searchField.stringValue == "" {
            ipaField.placeholderString =  "/tˈa‍ɪp tˈuː sˈɜːt‍ʃ/"
        }
        else {
            ipaField.placeholderString =  "/nˈɒt fˈa‍ʊnd/"
        }
        progressIndicator.stopAnimation(self)
    }
}
