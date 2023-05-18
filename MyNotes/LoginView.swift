//
//  ContentView.swift
//  MyNotes
//
//  Created by swostik gautam on 10/05/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var emailState: String = ""
    @State private var passwordState: String = ""
    @State var showsAlert = false
    var body: some View {
        NavigationView {
            ZStack{
                
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
                            login()
                        } label:{
                            Text("Log In")
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
                    NavigationLink("Don't have an account ? Register") {
                        RegisterUiView()
                    }
                }.padding()
                if authViewModel.loginLoading{
                    showProgressView()
                }
            }
            
        }
    }
    
    @ViewBuilder
    private func showProgressView() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .background(Color.black.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(10)
            .ignoresSafeArea()
    }
    
    private func login(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        authViewModel.login(email: self.emailState, password: self.passwordState)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
