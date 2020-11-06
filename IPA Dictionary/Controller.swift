// IPA Dictionary
// Copyright (C) 2020 Szymon Łopaciuk
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
