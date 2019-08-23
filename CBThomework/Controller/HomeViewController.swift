//
//  HomeViewController.swift
//  CBThomework
//
//  Created by Ricky Erdiansyah on 23/08/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import LocalAuthentication

class HomeViewController: UIViewController {

    var activities: [Activity] = []
    var logStatus: Bool = false
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBAction func faceButton(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use biometric authentication
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                reply: {(success, error) in
                    DispatchQueue.main.async {
                        
                        if let err = error {
                            
                            switch err._code {
                                
                            case LAError.Code.systemCancel.rawValue:
                                self.notifyUser("Session cancelled",
                                                err: err.localizedDescription)
                                
                            case LAError.Code.userCancel.rawValue:
                                self.notifyUser("Please try again",
                                                err: err.localizedDescription)
                                
                            case LAError.Code.userFallback.rawValue:
                                self.notifyUser("Authentication",
                                                err: "Password option selected")
                                // Custom code to obtain password here
                                
                            default:
                                self.notifyUser("Authentication failed",
                                                err: err.localizedDescription)
                            }
                            
                        } else {
                            self.notifyUser("Authentication Successful",
                                            err: "You now have full access")
                        }
                    }
            })
            
        } else {
            // Device cannot use biometric authentication
            if let err = error {
                switch err.code {
                    
                case LAError.Code.biometryNotEnrolled.rawValue:
                    notifyUser("User is not enrolled",
                               err: err.localizedDescription)
                    
                case LAError.Code.passcodeNotSet.rawValue:
                    notifyUser("A passcode has not been set",
                               err: err.localizedDescription)
                    
                    
                case LAError.Code.biometryNotAvailable.rawValue:
                    notifyUser("Biometric authentication not available",
                               err: err.localizedDescription)
                default:
                    notifyUser("Unknown error",
                               err: err.localizedDescription)
                }
            }
        }
        
    }
    
    
    @IBAction func switchAuthenticator(_ sender: UISwitch) {
        let context = LAContext()
        var error: NSError?
        
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use biometric authentication
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                reply: {(success, error) in
                    DispatchQueue.main.async {
                        
                        if let err = error {
                            
                            switch err._code {
                                
                            case LAError.Code.systemCancel.rawValue:
                                self.notifyUser("Session cancelled",
                                                err: err.localizedDescription)
                                
                            case LAError.Code.userCancel.rawValue:
                                self.notifyUser("Please try again",
                                                err: err.localizedDescription)
                                
                            case LAError.Code.userFallback.rawValue:
                                self.notifyUser("Authentication",
                                                err: "Password option selected")
                                // Custom code to obtain password here
                                
                            default:
                                self.notifyUser("Authentication failed",
                                                err: err.localizedDescription)
                            }
                            
                        } else {
                            self.notifyUser("Authentication Successful",
                                            err: "You now have full access")
                            if self.logStatus == false{
                                self.logStatus = true
                                self.titleLbl.text = "Welcome"
                            }else if self.logStatus == true {
                                self.logStatus = false
                                self.titleLbl.text = "Logged Out"
                            }
                        }
                    }
            })
            
        } else {
            // Device cannot use biometric authentication
            if let err = error {
                switch err.code {
                    
                case LAError.Code.biometryNotEnrolled.rawValue:
                    notifyUser("User is not enrolled",
                               err: err.localizedDescription)
                    
                case LAError.Code.passcodeNotSet.rawValue:
                    notifyUser("A passcode has not been set",
                               err: err.localizedDescription)
                    
                    
                case LAError.Code.biometryNotAvailable.rawValue:
                    notifyUser("Biometric authentication not available",
                               err: err.localizedDescription)
                default:
                    notifyUser("Unknown error",
                               err: err.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension HomeViewController{
    func notifyUser(_ msg: String, err : String?){
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
