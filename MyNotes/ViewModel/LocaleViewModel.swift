//
//  LocaleViewModel.swift
//  MyNotes
//
//  Created by swostik gautam on 03/06/2023.
//

import Foundation

class LocaleViewModel : ObservableObject {
    @Published var currentLocale: Locale = Locale.english
    init() {
        let currentLocaleKey : String = UserDefaults.standard.string(forKey: "currentLocaleKey") ?? ""
        if currentLocaleKey == Locale.nepali.rawValue {
            currentLocale = Locale.nepali
            return
        }
        currentLocale = Locale.english
    }
    private let myNotesLocale = MyNotesLocale.shared
    
    func getString(currentLocale:Locale, key:String) -> String {
        return myNotesLocale.getString(currentLocale: currentLocale, key: key)
    }
}


