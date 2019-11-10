//
//  ForgotPasswordViewController.swift
//  AWSAmplifyExperiment
//
//  Created by İlkay Aktaş on 9.07.2019.
//  Copyright © 2019 İlkay Aktaş. All rights reserved.
//

import UIKit
import AWSMobileClient

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var usernameView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var confirmationCodeView: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendCodeAction(_ sender: Any) {
        guard let username = usernameView.text, username != "" else {
            usernameView.shake()
            return
        }
        
        forgotPassword(username: username)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let username = usernameView.text, username != "",
                let password = passwordView.text, password != "",
                let confirmationCode = confirmationCodeView.text, confirmationCode != "" else {
            usernameView.shake()
            passwordView.shake()
            confirmationCodeView.shake()
            return
        }
        
        confirmForgotPassword(username: username, password: password, confirmationCode: confirmationCode)
    }
    
    func forgotPassword(username: String){
        showProgressIndicator(view: self.view, text: "Confirmation Code Sending!")
        
        AWSMobileClient.sharedInstance().forgotPassword(username: username) { (forgotPasswordResult, error) in
            
            hideAllProgressIndicators(view: self.view)
            
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    showMessage(title: "Confirmation Code Sent", message: "Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                    
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, delay: 0, animations: {
                            self.passwordView.isHidden = false
                            self.confirmationCodeView.isHidden = false
                            self.confirmButton.isHidden = false
                        }, completion: nil)
                        
                    }
                default:
                    showErrorMessage(title: "Error", message: "Error: Invalid case.")
                }
            } else if let error = error {
                showErrorMessage(title: "Error", message: "Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func confirmForgotPassword(username: String, password: String, confirmationCode: String){
        showProgressIndicator(view: self.view, text: "Confirming!")
        
        AWSMobileClient.sharedInstance().confirmForgotPassword(username: username, newPassword: password, confirmationCode: confirmationCode) { (forgotPasswordResult, error) in
            
            hideAllProgressIndicators(view: self.view)
            
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .done:
                    showMessage(title: "Successful", message: "Password changed successfully")
                default:
                    showErrorMessage(title: "Error", message: "Error: Could not change password.")
                }
            } else if let error = error {
                showErrorMessage(title: "Error", message: "Error occurred: \(error.localizedDescription)")
            }
        }
    }


}
