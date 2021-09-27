//
//  LoginViewController+TextField.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        currentText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if textField == emailTextField{
            loginViewModel.updateEmail(emailString: currentText)
        }else{
            loginViewModel.updatePassword(passString: currentText)
        }
        _ = loginViewModel.getCredentialStatus()
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else{
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
}
