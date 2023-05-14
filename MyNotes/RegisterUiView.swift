//
//  RegisterUiView.swift
//  MyNotes
//
//  Created by swostik gautam on 14/05/2023.
//

import SwiftUI

struct RegisterUiView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var emailState: String = String()
    @State private var passwordState: String = String()
    @Environment(\.presentationMode) var presentationMode
    @State var showsAlert = false
    var body: some View {
        ZStack{
            if authViewModel.registrationLoading{
                showProgressView()
            }
            VStack {
                CustomTextField(textFieldTitle: "Please enter your Email",
                                fieldLabel:"Email Address",
                                state: $emailState) { email in
                    isValidEmail(email)
                }
                CustomSecureField(textFieldTitle: "Please enter your Password",
                                  fieldLabel: "Password",
                                  state: $passwordState) { password in
                    isValidPassword(password)
                }
                NavigationLink(destination: HomeView() , isActive: $authViewModel.loginSuccess) {
                    Button {
                        register()
                    } label:{
                        Text("Register")
                            .padding(.vertical ,12)
                            .padding(.horizontal,12)
                            .frame(maxWidth: .infinity)
                    }
                    .alert(authViewModel.error, isPresented: $authViewModel.showError) {
                        Button("OK", role: .cancel) { }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical , 10)
                }
            }
            .disabled(authViewModel.loginLoading)
        }.onReceive(authViewModel.$registrationSuccess, perform: { registrationSuccess in
            if registrationSuccess {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .padding()
    }
    
    @ViewBuilder
    private func showProgressView() -> some View {
        ProgressView()
    }
    
    private func register(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        authViewModel.register(email: self.emailState, password: self.passwordState)
    }
}

