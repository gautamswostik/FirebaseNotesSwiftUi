//
//  MyNotesLocale.swift
//  MyNotes
//
//  Created by swostik gautam on 03/06/2023.
//

import Foundation

enum Locale : String , CaseIterable {
    case english = "English"
    case nepali = "Nepali"
}

enum MyNotesLocaleKeys : String {
    case emailAddress
    case enterEmail
    case password
    case enterPassword
    case logIn
    case gotoRegister
    case register
    case ok
    case cancel
    case logOut
    case addNote
    case title
    case description
    case settings
    case scanAgain
    case invalidQrFormat
    case qrDecodingError
    case needCameraAccess
    case unknownDeviceError
    case unknownQRError
}

class MyNotesLocale {
    static let shared = MyNotesLocale()
    
    var myNotesLocale : [Locale:[String:String]] = [:]
    private init () {
        setupEnglishLocale()
        setupNepaliLocale()
    }
    
    private func setupEnglishLocale() {
        var englishLocale: [String:String] = [:]
        
        englishLocale[MyNotesLocaleKeys.emailAddress.rawValue] = "Email Address"
        englishLocale[MyNotesLocaleKeys.enterEmail.rawValue] = "Please enter your Email"
        englishLocale[MyNotesLocaleKeys.password.rawValue] = "Password"
        englishLocale[MyNotesLocaleKeys.enterPassword.rawValue] = "Please enter your Password"
        englishLocale[MyNotesLocaleKeys.logIn.rawValue] = "Log In"
        englishLocale[MyNotesLocaleKeys.gotoRegister.rawValue] = "Don't have an account ? Register"
        englishLocale[MyNotesLocaleKeys.register.rawValue] = "Register"
        englishLocale[MyNotesLocaleKeys.ok.rawValue] = "OK"
        englishLocale[MyNotesLocaleKeys.cancel.rawValue] = "Cancel"
        englishLocale[MyNotesLocaleKeys.logOut.rawValue] = "Log Out?"
        englishLocale[MyNotesLocaleKeys.addNote.rawValue] = "Add Note"
        englishLocale[MyNotesLocaleKeys.title.rawValue] = "Title"
        englishLocale[MyNotesLocaleKeys.description.rawValue] = "Description"
        englishLocale[MyNotesLocaleKeys.settings.rawValue] = "Settings"
        englishLocale[MyNotesLocaleKeys.scanAgain.rawValue] = "Scan Again"
        englishLocale[MyNotesLocaleKeys.invalidQrFormat.rawValue] = "Invalid Qr Format"
        englishLocale[MyNotesLocaleKeys.qrDecodingError.rawValue] = "Error While decoding"
        englishLocale[MyNotesLocaleKeys.needCameraAccess.rawValue] = "Need camera access for scanning QR"
        englishLocale[MyNotesLocaleKeys.unknownDeviceError.rawValue] = "UNNKNOWN DEVICE ERROR"
        englishLocale[MyNotesLocaleKeys.unknownQRError.rawValue] = "UNNKNOWN QR ERROR"
        
        myNotesLocale[Locale.english] = englishLocale
    }
    
    private func setupNepaliLocale() {
        var nepaliLocale: [String:String] = [:]
        
        nepaliLocale[MyNotesLocaleKeys.emailAddress.rawValue] = "इ - मेल ठेगाना"
        nepaliLocale[MyNotesLocaleKeys.enterEmail.rawValue] = "कृपया आफ्नो इमेल प्रविष्ट गर्नुहोस्"
        nepaliLocale[MyNotesLocaleKeys.password.rawValue] = "पासवर्ड"
        nepaliLocale[MyNotesLocaleKeys.enterPassword.rawValue] = "कृपया आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्"
        nepaliLocale[MyNotesLocaleKeys.logIn.rawValue] = "लग - इन"
        nepaliLocale[MyNotesLocaleKeys.gotoRegister.rawValue] = "खाता छैन? दर्ता गर्नुहोस्"
        nepaliLocale[MyNotesLocaleKeys.register.rawValue] = "दर्ता गर्नुहोस्"
        nepaliLocale[MyNotesLocaleKeys.ok.rawValue] = "ठिक छ"
        nepaliLocale[MyNotesLocaleKeys.cancel.rawValue] = "रद्द गर्नुहोस्"
        nepaliLocale[MyNotesLocaleKeys.logOut.rawValue] = "बाहिर निस्कनु?"
        nepaliLocale[MyNotesLocaleKeys.addNote.rawValue] = "नोट थप्नुहोस्"
        nepaliLocale[MyNotesLocaleKeys.title.rawValue] = "शीर्षक"
        nepaliLocale[MyNotesLocaleKeys.description.rawValue] = "विवरण"
        nepaliLocale[MyNotesLocaleKeys.settings.rawValue] = "सेटिङहरू"
        nepaliLocale[MyNotesLocaleKeys.scanAgain.rawValue] = "फेरि स्क्यान गर्नुहोस्"
        nepaliLocale[MyNotesLocaleKeys.invalidQrFormat.rawValue] = "अवैध Qr ढाँचा"
        nepaliLocale[MyNotesLocaleKeys.qrDecodingError.rawValue] = "डिकोडिङ गर्दा त्रुटि"
        nepaliLocale[MyNotesLocaleKeys.needCameraAccess.rawValue] = "QR स्क्यान गर्न क्यामेरा पहुँच आवश्यक छ"
        nepaliLocale[MyNotesLocaleKeys.unknownDeviceError.rawValue] = "अज्ञात यन्त्र त्रुटि"
        nepaliLocale[MyNotesLocaleKeys.unknownQRError.rawValue] = "अज्ञात QR त्रुटि"
        
        myNotesLocale[Locale.nepali] = nepaliLocale
    }
    
    func getString(currentLocale:Locale, key:String) -> String {
        guard myNotesLocale[currentLocale]!.keys.contains(key) else {
            return "No Such String"
        }
        return myNotesLocale[currentLocale]?[key] ?? ""
    }
}
