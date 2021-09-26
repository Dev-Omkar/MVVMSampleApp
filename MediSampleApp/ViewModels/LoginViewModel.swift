//
//  LoginViewModel.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//
import UIKit
import Foundation
class LoginViewModel {
    
    private var email = ""
    private var password = ""
    
    private let loginManager: LoginApiService
     
    var isValidCredentials: Observable<Bool> = Observable(false)
    
    init(loginManager: LoginApiService) {
        self.loginManager = loginManager
    }
    
    func updatePassword(passString:String){
        password = passString
    }
    func updateEmail(emailString:String){
        email = emailString
    }
    func getCredentialStatus() -> (LoginStatus,String) {
        if email.isEmpty && password.isEmpty {
            isValidCredentials.value = false
            return (.invalid,"Email and password required.")
        }
        
        if email.isEmpty {
            isValidCredentials.value = false
            return (.invalid,"Email is required.")
        }
        
        if password.isEmpty {
            isValidCredentials.value = false
            return (.invalid, "Password is required.")
        }
        
        if !validEmail(inputEmail: email) {
            isValidCredentials.value = false
            return (.invalid, "Invalid email id.")
        }
        
        if !validPasswordLength(password: password) {
            isValidCredentials.value =  false
            return (.invalid, "Password should be atleast 8 and max 15.")
        }
        
        isValidCredentials.value = true
        let status = LoginStatus.init(rawValue: isValidCredentials.value.intValue) ?? .invalid
        return (status, "Success")
    }
    
    
    private func validEmail(inputEmail:String) -> Bool {
        let emailFormat = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return predicate.evaluate(with: inputEmail)
        
    }
    
    private func validPasswordLength(password:String) -> Bool {
        if password.count >= 8 && password.count <= 15{
            return true
        }
        return false
    }
}

