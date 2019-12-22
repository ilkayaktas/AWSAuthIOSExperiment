//
//  SplashViewController.swift
//  AWSAmplifyExperiment
//
//  Created by İlkay Aktaş on 19.07.2019.
//  Copyright © 2019 İlkay Aktaş. All rights reserved.
//

import UIKit
import AWSMobileClient

class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        showProgressIndicator(view: view, text: "Signing In!")
        AWSMobileClient.default().initialize { (userState, error) in
            if let error = error {
                showErrorMessage(title: "Error", message: "\(error.localizedDescription)")
                return
            }
            
            guard let userState = userState else {
                return
            }
            
            hideAllProgressIndicators(view: self.view)
            
            // Check if user availability
            switch userState {
            case .signedIn:
//                print("\(userState.rawValue) \(AWSMobileClient.default().getCredentialsProvider().identityId!) \(AWSMobileClient.default().getCredentialsProvider().identityPoolId)")
                // Show home page
                self.performSegue(withIdentifier: "segueToStorageFromSplash", sender: self)
                break
                
            default:
                self.performSegue(withIdentifier: "segueToSignInFromSplash", sender: self)
                break
            }
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToStorageFromSplash"{
            let destinationViewController = segue.destination as! StorageViewController
            
            destinationViewController.credentialProvider = AWSMobileClient.default().getCredentialsProvider()
        }
    }*/

}


extension SplashViewController{
    @IBAction func backToSplashViewController(_ segue: UIStoryboardSegue) {
    }
}
