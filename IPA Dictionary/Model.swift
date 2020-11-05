//
//  Model.swift
//  
//
//  Created by Szymon Łopaciuk on 2020-11-05.
//

import Cocoa

class Model: NSObject {
    var dictionary: [String: String] = [:]
    var languageCode: String
    
    static let languageCodeToName = [
        "ar": "Arabic (Modern Standard)",
        "de": "German",
        "en_UK": "English (Received Pronunciation)",
        "en_US": "English (General American)",
        "eo": "Esperanto",
        "es_ES": "Spanish (Spain)",
        "es_MX": "Spanish (Mexico)",
        "fa": "Persian",
        "fi": "Finnish",
        "fr_FR": "French (France)",
        "fr_QC": "French (Québec)",
        "is": "Icelandic",
        "ja": "Japanese",
        "jam": "Jamaican Creole",
        "km": "Khmer",
        "ko": "Korean",
        "ma": "Malay (Malaysian and Indonesian)",
        "nb": "Norwegian Bokmål",
        "or": "Odia",
        "ro": "Romanian",
        "sv": "Swedish",
        "sw": "Swahili",
        "tts": "Isan",
        "vi_C": "Vietnamese (Central)",
        "vi_N": "Vietnamese (Northern)",
        "vi_S": "Vietnamese (Southern)",
        "yue": "Cantonese",
        "zh_hans": "Mandarin (Simplified)",
        "zh_hant": "Mandarin (Traditional)",
    ]
    
    static let languageNameToCode = Dictionary(uniqueKeysWithValues: languageCodeToName.map({ ($1, $0) }))
    
    static var activeInstance: Model?
    
    init(for languageCode: String) {
        self.languageCode = languageCode
        
        super.init()
        
        let dbPath = Bundle.main.path(forResource: "data/" + languageCode, ofType: "txt")!
        let content = try! String(contentsOfFile: dbPath, encoding: .utf8)
        self.dictionary = parseFile(contents: content)
    }
    
    static func instance(for languageCode: String) -> Model {
        if let instance = self.activeInstance {
            if instance.languageCode == languageCode {
                return instance
            }
        }
        let instance = Model(for: languageCode)
        self.activeInstance = instance
        return instance
    }
    
    static func availableLanguageFiles() -> [String] {
        let dbPath = Bundle.main.resourcePath! + "/data/"
        let fileNames = try! FileManager.default.contentsOfDirectory(atPath: dbPath)
        return fileNames
    }
    
    static func availableLanguages() -> [String] {
        availableLanguageFiles().map {
            let code = String($0.split(separator: ".")[0])
            return languageCodeToName[code] ?? "Unknown"
        }.sorted()
    }
    
    func parseFile(contents: String) -> [String: String] {
        var result = [String: String]()
        let rows = contents.components(separatedBy: "\n")
        for row in rows {
            if row.isEmpty {
                continue
            }
            let columns = row.components(separatedBy: "\t")
            result[columns[0]] = columns[1]
        }
        return result
    }
    
    func ipaFor(spelling word: String) -> String? {
        self.dictionary[word]?.replacingOccurrences(of: ",", with: ", ")
    }
}
