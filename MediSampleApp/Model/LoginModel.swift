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
enum LoginStatus: Int {
    case valid = 1
    case invalid = 0
}

