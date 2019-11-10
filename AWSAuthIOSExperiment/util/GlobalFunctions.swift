//
//  GlobalFunctions.swift
//  AWSAmplifyExperiment
//
//  Created by İlkay Aktaş on 8.07.2019.
//  Copyright © 2019 İlkay Aktaş. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import RMessage

let rControl = RMController()

func showProgressIndicator(view: UIView, text: String){
    DispatchQueue.main.async {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = text
    }
}

func hideAllProgressIndicators(view: UIView){
    DispatchQueue.main.async {
        MBProgressHUD.hide(for: view, animated: true)
    }
}

func showErrorMessage(title: String, message: String){
    DispatchQueue.main.async {
        rControl.showMessage(
            withSpec: errorSpec,
            title: title,
            body: message
        )
    }
}

func showMessage(title: String, message: String){
    DispatchQueue.main.async {
        rControl.showMessage(
            withSpec: normalSpec,
            title: title,
            body: message
        )
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        self.layer.add(animation, forKey: "shake")
    }
    
    func shakeWithRotation() {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map {
            ( degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = 0.4
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
}
