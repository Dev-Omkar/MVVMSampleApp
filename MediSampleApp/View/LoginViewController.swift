//
//  ViewController.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - ViewModels
    var loginViewModel: LoginViewModel!
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: - IBActions
    @IBAction func loginAction(_ sender: UIButton) {
        /* let (status,message) = loginViewModel.getCredentialStatus()
         if status == .valid{
         
         }else{
         print(message)
         }*/
    }
    private func goToFeeds(){
        
    }
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForValidCredentials()
    }
    
    //MARK: - Helper Methods
    func listenForValidCredentials(){
        loginViewModel.isValidCredentials.bind { [weak self] validCredentials in
            print(validCredentials)
            if validCredentials{
                self?.submitButton.alpha = 1;
            }else{
                self?.submitButton.alpha = 0.5;
            }
            self?.submitButton.isEnabled = validCredentials
        }
        
    }
    
    
}





