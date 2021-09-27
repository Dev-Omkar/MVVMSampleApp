//
//  LoginModel.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import Foundation

struct LoginModel {
    var email: String = ""
    var password: String = ""
}

struct LoginResponseModel {
    var success: Bool = true
    var message: String = ""
    var data: LoginModel = LoginModel.init()
}

struct LogoutResponseModel {
    var success: Bool = true
    var message: String = ""
    var data: LoginModel = LoginModel.init()
}

enum LoginStatus: Int {
    case valid = 1
    case invalid = 0
}

