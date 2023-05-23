//
//  AuthViewModel.swift
//  MyNotes
//
//  Created by swostik gautam on 14/05/2023.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var loginLoading:Bool = Bool()
    @Published var showError:Bool = Bool()
    @Published var loginSuccess:Bool = Bool()
    @Published var logOutSuccess:Bool = Bool()
    @Published var registrationSuccess:Bool = Bool()
    @Published var registrationLoading:Bool = Bool()
    @Published var error:String = String()
    
    
    
    init () {}
    
    
    func login(email:String , password:String) {
        if email.isEmpty || password.isEmpty {
            self.showError = true
            self.error = "Please fill both fields"
            return
        }
        if  !isValidEmail(email) && !isValidPassword(password) {
            self.showError = true
            self.error = "Provided details are invalid"
            return
        }
        self.loginLoading = true
        Auth.auth().signIn(withEmail: email, password: password) {(result , error) in
            if error != nil {
                self.loginLoading = false
                self.showError = true
                self.error = error?.localizedDescription ?? "Something Went Wrong"
                return
            }
            self.loginLoading = false
            self.loginSuccess = true
        }
    }
    
    func register(email:String , password:String) {
        if email.isEmpty || password.isEmpty {
            self.showError = true
            self.error = "Please fill both fields"
            return
        }
        if  !isValidEmail(email) && !isValidPassword(password) {
            self.showError = true
            self.error = "Provided details are invalid"
            return
        }
        self.registrationLoading = true
        Auth.auth().createUser(withEmail: email, password: password) {(result , error) in
            if error != nil {
                self.registrationLoading = false
                self.showError = true
                self.error = error?.localizedDescription ?? "Something Went Wrong"
                return
            }
            self.registrationLoading = false
            self.registrationSuccess = true
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.logOutSuccess = true
        } catch {
            self.showError = true
            self.error = error.localizedDescription
        }
        
    }
}
