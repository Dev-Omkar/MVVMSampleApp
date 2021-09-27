//
//  Utility.swift
//  MediSampleApp
//
//  Created by MacStar on 27/09/21.
//

import Foundation

struct AppConfig{
    static  var serverUrl:String {
        get {
            Bundle.main.infoDictionary?["SERVERURL"] as? String ?? ""
        }
    }
}
