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
     
    var isValidCredentials: Observable<Bool> = Observable(false)
    var userMessage: Observable<String> = Observable("")
     
    //MARK:-  Helpers
    func clearData(){
        email = ""
        password = ""
        isValidCredentials.value = false
    }
    func updatePassword(passString:String){
        password = passString
    }
    func updateEmail(emailString:String){
        email = emailString
    }
    
    //MARK:-  Action Method
    func performLogin(completion:@escaping (Result<LoginResponseModel, ApiError>)-> Void){
        ApiService.sharedInstance.postLogin(email:email,password:password) { (response) in
            completion(response)
        }
    }
    
    
    func getCredentialStatus() -> (LoginStatus,String) {
        if email.isEmpty && password.isEmpty {
            isValidCredentials.value = false
            userMessage.value = "Email and password is required."
            return (.invalid,userMessage.value)
        }
        
        if email.isEmpty {
            isValidCredentials.value = false
            userMessage.value = "Email is required."
            return (.invalid,userMessage.value)
        }
        if !validEmail(inputEmail: email) {
            isValidCredentials.value = false
            userMessage.value = "Invalid email."
            return (.invalid, userMessage.value)
        }
        
        if password.isEmpty {
            isValidCredentials.value = false
            userMessage.value = "Password is required."
            return (.invalid,userMessage.value)
        }
        
        if !validPasswordLength(password: password) {
            isValidCredentials.value =  false
            userMessage.value = "Password should be atleast 8 and max 15 characters."
            return (.invalid, userMessage.value)
        }
        
        isValidCredentials.value = true
        let status = LoginStatus.init(rawValue: isValidCredentials.value.intValue) ?? .invalid
        userMessage.value = ""
        return (status, "Success")
    }
    
    //MARK:-  Validation Helpers
    private func validEmail(inputEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
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

