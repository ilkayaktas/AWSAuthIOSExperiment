//
//  SignupViewController.swift
//  AWSAmplifyExperiment
//
//  Created by İlkay Aktaş on 7.07.2019.
//  Copyright © 2019 İlkay Aktaş. All rights reserved.
//

import UIKit
import AWSMobileClient

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var confirmationCodeView: UITextField!
    @IBOutlet weak var enterCodeButton: UIButton!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signUpAction(_ sender: Any) {
        guard let username = usernameView.text, username != "",
            let password = passwordView.text, password != "" else {
                usernameView.shake()
                passwordView.shake()
                return
        }
        
        signUp(username: username, password: password)
    }
    
    @IBAction func enterCodeAction(_ sender: Any) {
        guard let username = usernameView.text, username != "",
            let code = confirmationCodeView.text, code != "" else {
                confirmationCodeView.shake()
                usernameView.shake()
                return
        }
        
        confirmSignUp(username: username, confirmationCode: code)
    }
 
    @IBAction func resendCodeAction(_ sender: Any) {
        guard let username = usernameView.text, username != "" else {
                usernameView.shake()
                return
        }
        
        resendConfirmationCode(username: username)
    }
    
    func signUp(username: String, password: String){
        
        showProgressIndicator(view: self.view, text: "Signing Up!")
        
        AWSMobileClient.sharedInstance().signUp(username: username, password: password, userAttributes: [:]) {
                (signUpResult, error) in
            
                    hideAllProgressIndicators(view: self.view)
            
                    if let signUpResult = signUpResult {
                        switch(signUpResult.signUpConfirmationState) {
                        case .confirmed:
                            showMessage(title: "Sign Up Succesful", message: "User is signed up and confirmed.")
                        case .unconfirmed:
                            showMessage(title: "Confirmation Required", message: "User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")

                            DispatchQueue.main.async {
                                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                                    self.confirmationCodeView.isHidden = false
                                    self.enterCodeButton.isHidden = false
                                    self.resendCodeButton.isHidden = false
                                }, completion: nil)
                                
                            }
                        case .unknown:
                            showErrorMessage(title: "Error", message: "Unexpected case on sign up.")
                        }
                    } else if let error = error {
                        if let error = error as? AWSMobileClientError {
                            switch(error) {
                            case .usernameExists(let message):
                                showErrorMessage(title: "Error", message: message)
                            default:
                                break
                            }
                        }
                        showErrorMessage(title: "Error", message: "\(error.localizedDescription)")
                    }
            }
    }
    
    func confirmSignUp(username: String, confirmationCode : String){
        showProgressIndicator(view: self.view, text: "Signing Up!")
        
        AWSMobileClient.sharedInstance().confirmSignUp(username: username, confirmationCode: confirmationCode) {
            (signUpResult, error) in
            
                hideAllProgressIndicators(view: self.view)
            
            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    showMessage(title: "Confirmation Successful", message: "User is signed up and confirmed.")

                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, delay: 0, animations: {
                            self.confirmationCodeView.isHidden = true
                            self.enterCodeButton.isHidden = true
                            self.resendCodeButton.isHidden = true
                        }, completion: nil)
                        
                        self.performSegue(withIdentifier: "segueToSignIn", sender: self)
                    }
                    
                case .unconfirmed:
                    showErrorMessage(title: "Error", message: "User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                case .unknown:
                    showErrorMessage(title: "Error", message: "Unexpected case on confirmation.")
                }
            } else if let error = error {
                showErrorMessage(title: "Error", message: "\(error.localizedDescription)")
            }
        }
    }
    
    func resendConfirmationCode(username: String){
        showProgressIndicator(view: self.view, text: "Resending Confirmation Code!")
        
        AWSMobileClient.sharedInstance().resendSignUpCode(username: username, completionHandler: { (result, error) in
            hideAllProgressIndicators(view: self.view)
            
            if let signUpResult = result {
                showMessage(title: "Confirmation Code Resent", message: "A verification code has been sent via \(signUpResult.codeDeliveryDetails!.deliveryMedium) at \(signUpResult.codeDeliveryDetails!.destination!)")
            } else if let error = error {
                showErrorMessage(title: "Error", message: "\(error.localizedDescription)")
            }
        })
    }

    func getToken(){
        AWSMobileClient.sharedInstance().getTokens { (tokens, error) in
            if let error = error {
                showErrorMessage(title: "Token", message: "Error getting token \(error.localizedDescription)")
            } else if let tokens = tokens {
                showMessage(title: "Token", message: tokens.accessToken!.tokenString!)
            }
        }
    }
    
    func getAWSCredentials(){
        AWSMobileClient.sharedInstance().getAWSCredentials { (credentials, error) in
            if let error = error {
                showErrorMessage(title: "Error", message: "\(error.localizedDescription)")
            } else if let credentials = credentials {
                showMessage(title: "Credentials", message: credentials.accessKey)
            }
        }
    }
    
    func rememberDevice(){
        AWSMobileClient.sharedInstance().deviceOperations.updateStatus(remembered: true) { (result, error) in
            if let error = error {
                showErrorMessage(title: "Error", message: "\(error.localizedDescription)")
            } else if let result = result {
                showMessage(title: "Credentials", message: "Remembered!")
            }
        }
    }
}

extension SignUpViewController{
    @IBAction func backToSignUpViewController(_ segue: UIStoryboardSegue) {
    }
}
