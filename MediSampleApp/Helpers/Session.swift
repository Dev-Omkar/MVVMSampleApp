//
//  LoginManager.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation

struct SessionData {
    @Session(key: "email", defaultValue: "")
    static var email: String
    
    @Session(key: "password", defaultValue: "")
    static var password: String
    
    @Session(key: "isUserLoggedIn", defaultValue: false)
    static var isUserLoggedIn: Bool
}



@propertyWrapper
struct Session<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        } set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


