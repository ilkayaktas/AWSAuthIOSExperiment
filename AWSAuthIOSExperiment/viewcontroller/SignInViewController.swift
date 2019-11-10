//
//  SiginViewController.swift
//  AWSAmplifyExperiment
//
//  Created by İlkay Aktaş on 7.07.2019.
//  Copyright © 2019 İlkay Aktaş. All rights reserved.
//

import UIKit
import AWSMobileClient

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameView: UITextField!
    @IBOutlet var passwordView: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToStorage"{
            let destinationViewController = segue.destination as! StorageViewController
            
            destinationViewController.credentialProvider = AWSMobileClient.sharedInstance().getCredentialsProvider()
        }
    }
    
    @IBAction func signInAction(_ sender: Any) {
        guard let username = usernameView.text, username != "",
            let password = passwordView.text, password != "" else {
                usernameView.shakeWithRotation()
                passwordView.shakeWithRotation()
                return
        }
        signIn(username: username, password: password)
    }
    
    func signIn(username: String, password: String){
        
        showProgressIndicator(view: self.view, text: "Signing In!")
        AWSMobileClient.sharedInstance().signIn(username: username, password: password, completionHandler: {
            (signInResult, error) in
            
            hideAllProgressIndicators(view: self.view)

            if error != nil {
                showErrorMessage(title: "Error", message: "Error occured in sign in \(String(describing:error))")
            } else{
                switch (signInResult!.signInState) {
                case .signedIn:
                    showMessage(title: "Successful", message: "User is signed in.")
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segueToStorage", sender: self)
                    }
                case .smsMFA:
                    showMessage(title: "SMS Verification Required", message: "SMS message sent to \(String(describing: signInResult?.codeDetails!.destination!))")
                default:
                    showErrorMessage(title: "Error", message: "Sign In needs info which is not et supported.")
                }
            }
            
        })
    }
    
    func forgotPassword(username: String){
        AWSMobileClient.sharedInstance().forgotPassword(username: username) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    print("Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                default:
                    print("Error: Invalid case.")
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func confirmForgotPassword(username: String, password: String, confirmationCode: String){
        AWSMobileClient.sharedInstance().confirmForgotPassword(username: username, newPassword: password, confirmationCode: confirmationCode) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .done:
                    print("Password changed successfully")
                default:
                    print("Error: Could not change password.")
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
}

extension SignInViewController{
    @IBAction func backToSignInViewController(_ segue: UIStoryboardSegue) {
    }
}
