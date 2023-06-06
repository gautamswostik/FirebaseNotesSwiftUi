//
//  MyNotesApp.swift
//  MyNotes
//
//  Created by swostik gautam on 10/05/2023.
//

import SwiftUI

struct MyNotesApp: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let localeViewModel = LocaleViewModel()
    var body: some View {
        LoginView()
            .environmentObject(localeViewModel)
    }
}
