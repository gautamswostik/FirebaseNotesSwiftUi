//
//  ContentView.swift
//  MyNotes
//
//  Created by swostik gautam on 10/05/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var localeViewModel: LocaleViewModel
    @StateObject var authViewModel = AuthViewModel()
    @State private var emailState: String = String()
    @State private var passwordState: String = String()
    @State private var showLanguageSheet: Bool = Bool()
    @State var showsAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    NavigationLink(destination: MyNotesView() , isActive: $authViewModel.loginSuccess) {
                        Button {
                            login()
                        } label:{
                            Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.logIn.rawValue))
                                .foregroundColor(.white)
                                .padding(.vertical ,12)
                                .padding(.horizontal,12)
                                .frame(maxWidth: .infinity)
                        }
                        .alert(isPresented: $authViewModel.showError) {
                            Alert(title: Text(authViewModel.error),dismissButton: .cancel(Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.ok.rawValue))))
                        }
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding(.vertical , 10)
                    }
                    NavigationLink{
                        QrScannerView(authViewModel: authViewModel)
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 45))
                            .foregroundColor(.black)
                    }.padding(.vertical , 20)
                    NavigationLink(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.gotoRegister.rawValue)) {
                        RegisterUiView()
                    }
                }.padding()
                if authViewModel.loginLoading{
                    ShowProgressView()
                }

            }
            .onReceive(authViewModel.$loginSuccess) { loginSucces in
                if loginSucces {
                    emailState = ""
                    passwordState = ""
                }
            }
            .navigationBarItems(trailing: Button {
                showLanguageSheet.toggle()
            } label: {
                Image(systemName: "globe")
                    .foregroundColor(.black)
            }.padding(.top , 20)
                .padding(.trailing , 20))
            .sheet(isPresented: $showLanguageSheet) {
                VStack {
                    ForEach(Locale.allCases , id: \.self){ locale in
                        Button {
                            localeViewModel.currentLocale = locale
                            showLanguageSheet.toggle()
                            UserDefaults.standard.set(locale.rawValue, forKey: "currentLocaleKey")
                        } label: {
                            HStack {
                                Image(locale.rawValue)
                                    .resizable()
                                    .frame(width:24 , height: 24)
                                Spacer()
                                Text(locale.rawValue)
                                
                            }.padding(.horizontal , 20)
                        }
                    }
                }
                //                .presentationDetents([.fraction(0.15) , .large])
            }
            
        }
    }
    
    private func login(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        authViewModel.login(email: self.emailState, password: self.passwordState)
    }
}
