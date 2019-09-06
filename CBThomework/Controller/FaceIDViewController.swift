//
//  FaceIDViewController.swift
//  CBThomework
//
//  Created by Alan Santoso on 05/09/19.
//  Copyright © 2019 Alan Santoso. All rights reserved.
//

import UIKit
import LocalAuthentication

class FaceIDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let context: LAContext = LAContext()
        let defaults = UserDefaults.standard
        let faceID = defaults.bool(forKey: "FaceID")
        
        if faceID == true {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "message") { (good, error) in
                    if good {
                        print("GOOD")
                        self.performSegue(withIdentifier: "toHome", sender: nil)
                        
                    }
                    else {
                        print("ERROR")
                        self.performSegue(withIdentifier: "toHome", sender: nil)

                    }
                }
            }
        }else {
            

        }
        
        
        
        
        
        
        
        
        
    }
    
}
