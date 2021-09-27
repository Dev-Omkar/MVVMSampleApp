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

import UIKit
class AlertHelper {
    static func showAlert(title: String?, message: String?, over viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        viewController.present(ac, animated: true)
    }
}
