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
        self.view.endEditing(true)
        loginViewModel.performLogin {  [weak self] (response) in
            switch(response){
            case .success(let responseModel):
                if responseModel.success{
                    SessionData.email = responseModel.data.email
                    SessionData.password = responseModel.data.password
                    SessionData.isUserLoggedIn = true
                    self?.performSegue(withIdentifier: "postTabSegue", sender: self)
                }else{
                    if let currentSelf = self{
                    AlertHelper.showAlert(title: "Alert", message: responseModel.message, over:  currentSelf)
                    }
                }
                break
            case .failure(let error):
                if let currentSelf = self{
                    AlertHelper.showAlert(title: "Alert", message: error.localizedDescription, over:  currentSelf)
                }
                break
            }
        }
        
    }
    
    private func goToFeeds(){
        
    }
    //MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if SessionData.isUserLoggedIn{
            self.performSegue(withIdentifier: "postTabSegue", sender: self)
        }else{
            listenForValidCredentials()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        clearPreviousInput()
    }
    func clearPreviousInput(){
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        loginViewModel.clearData()
        if !SessionData.isUserLoggedIn{
            listenForValidCredentials()
        }
    }
    //MARK: - Helper Methods
    func listenForValidCredentials(){
        loginViewModel.isValidCredentials.bind { [weak self] validCredentials in
           
            if validCredentials{
                self?.submitButton.alpha = 1;
            }else{
                self?.submitButton.alpha = 0.5;
            }
            self?.submitButton.isEnabled = validCredentials
        }
        
    }
    
    
}





