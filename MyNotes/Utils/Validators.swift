//
//  ValidatorMethods.swift
//  MyNotes
//
//  Created by swostik gautam on 12/05/2023.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

func isValidPassword(_ password: String) -> Bool {
    let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*]).{10,}$"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
}
