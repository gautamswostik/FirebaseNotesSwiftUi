//
//  MyNotesApp.swift
//  MyNotes
//
//  Created by swostik gautam on 10/05/2023.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct MyNotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let localeViewModel = LocaleViewModel()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(localeViewModel)
        }
    }
}
