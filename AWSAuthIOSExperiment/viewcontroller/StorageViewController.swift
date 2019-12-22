//
//  StorageViewController.swift
//  AWSAmplifyExperiment
//
//  Created by İlkay Aktaş on 11.07.2019.
//  Copyright © 2019 İlkay Aktaş. All rights reserved.
//

import UIKit
import AWSMobileClient

class StorageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var credentialProvider : AWSCognitoCredentialsProvider?
    let progressView: UIProgressView! = UIProgressView()
    
//    @objc var completionHandlerForUpload: AWSS3TransferUtilityUploadCompletionHandlerBlock?
//    @objc var completionHandlerForDownload: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
//    @objc var progressBlock: AWSS3TransferUtilityProgressBlock?

    /*
    @objc lazy var transferUtility = {
        AWSS3TransferUtility.default()
    }()
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.progress = 0.0;

        /*
        self.createTransferUtility()
        
        self.uploadData()
        
        self.downloadData()
        */
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        AWSMobileClient.default().signOut()
    }
    
    /*
    func createTransferUtility(){
        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
        
        //Setup the transfer utility configuration
        let tuConf = AWSS3TransferUtilityConfiguration()
        tuConf.isAccelerateModeEnabled = true
        
        
        //Register a transfer utility object asynchronously
        AWSS3TransferUtility.register(
            with: configuration!,
            transferUtilityConfiguration: tuConf,
            forKey: "transfer-utility-with-advanced-options"
        ) { (error) in
            if let error = error {
                showErrorMessage(title: "Error", message: "\(error.localizedDescription)")
            }
        }
        
        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                self.progressView.progress = Float(progress.fractionCompleted)
                print("Uploading! \(Float(progress.fractionCompleted))")
            })
        }
        
        self.completionHandlerForUpload = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                hideAllProgressIndicators(view: self.view)
                if let error = error {
                    showErrorMessage(title: "Error", message: "Failed with error: \(error)")
                    print("\(error)")
                }
                else if(self.progressView.progress != 1.0) {
                    showErrorMessage(title: "Error", message: "Upload Failed!")
                } else {
                    showMessage(title: "Success", message: "Upload is completed!")
                }
            })
        }
    }
    
    
    func uploadData() {
        
        showProgressIndicator(view: self.view, text: "Uploading!")
        
        let data: Data = (UIImage(named: "brainifia.png")?.pngData())! // Data to be uploaded
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        
        print("Identity id: \(AWSMobileClient.default().identityId!)")
        transferUtility.uploadData(
            data,
            key: "private/\(AWSMobileClient.default().identityId!)/brainifia.png",
            contentType: "image/png",
            expression: expression,
            completionHandler: completionHandlerForUpload).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        print("Error on upload: \(error.localizedDescription)")
                    }
                }
                
                if let _ = task.result {
                    DispatchQueue.main.async {
                        print("Upload Starting!")
                    }
                }
                
                return nil;
        }
        
    }
    
    func downloadData() {
        showProgressIndicator(view: self.view, text: "Downloading!")
        
        let expression = AWSS3TransferUtilityDownloadExpression()
            expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
                print("Downloading! \(Float(progress.fractionCompleted))")
                self.progressView.progress = Float(progress.fractionCompleted)
            })
        }
        
        completionHandlerForDownload = { (task, location, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                
                hideAllProgressIndicators(view: self.view)
                if let error = error {
                    showErrorMessage(title: "Error", message: "Failed with error: \(error)")
                    print("\(error)")
                }
                else if(self.progressView.progress != 1.0) {
                    showErrorMessage(title: "Error", message: "Download Failed!")
                } else {
                    showMessage(title: "Success", message: "Download is completed!")
                    self.imageView.image = UIImage(data: data!)
                }
            })
        }
        
        transferUtility.downloadData(
            forKey: "private/\(AWSMobileClient.default().identityId!)/brainifia1.png",
            expression: expression,
            completionHandler: completionHandlerForDownload).continueWith { (task) -> AnyObject? in
                if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    DispatchQueue.main.async(execute: {
                        print("Download Starting!")
                    })
                    
                }
                return nil;
        }
    }
    */
}
