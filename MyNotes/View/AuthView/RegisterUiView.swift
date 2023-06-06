//
//  RegisterUiView.swift
//  MyNotes
//
//  Created by swostik gautam on 14/05/2023.
//

import SwiftUI

struct RegisterUiView: View {
    @EnvironmentObject var localeViewModel: LocaleViewModel
    @StateObject var authViewModel = AuthViewModel()
    @State private var emailState: String = String()
    @State private var passwordState: String = String()
    @Environment(\.presentationMode) var presentationMode
    @State var showsAlert = false
    var body: some View {
        ZStack{
            VStack {
                CustomTextField(textFieldTitle: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.enterEmail.rawValue),
                                fieldLabel:localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.emailAddress.rawValue),
                                state: $emailState) { email in
                    isValidEmail(email)
                }
                CustomSecureField(textFieldTitle: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.enterPassword.rawValue),
                                  fieldLabel: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.password.rawValue),
                                  state: $passwordState) { password in
                    isValidPassword(password)
                }
                Button {
                    register()
                } label:{
                    Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.register.rawValue))
                        .foregroundColor(.white)
                        .padding(.vertical ,12)
                        .padding(.horizontal,12)
                        .frame(maxWidth: .infinity)
                }
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .alert(isPresented: $authViewModel.showError) {
                    Alert(title: Text(authViewModel.error),dismissButton: .cancel(Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.ok.rawValue))))
                }
                .padding(.vertical , 10)
                
            }.padding()
            if authViewModel.registrationLoading{
                ShowProgressView()
            }
        }.onReceive(authViewModel.$registrationSuccess, perform: { registrationSuccess in
            if registrationSuccess {
                presentationMode.wrappedValue.dismiss()
            }
        })
        
    }
    
    private func register(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        authViewModel.register(email: self.emailState, password: self.passwordState)
    }
}

