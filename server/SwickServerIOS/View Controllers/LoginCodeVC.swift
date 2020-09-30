//
//  LoginCodeVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 9/11/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class LoginCodeVC: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    var email : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make enter button have rounded edges
        enterButton.layer.cornerRadius = 10
        
        // Make keyboard appear
        codeTextField.becomeFirstResponder()
    }
    
    @IBAction func enterButtonClicked(_ sender: Any) {
        // Send verification code to get token
        API.getToken(email, codeTextField.text ?? "") { json in
            
            let token = json["token"].string
            // If token unsuccessfully retrieved
            if token == nil {
                Helper.alert(self, message: "Invalid verfication code. Please try again.")
            }
            // If token successfully retrieved
            else {
                UserDefaults.standard.set(token, forKey: "token")
                
                // Create acocunt on backend and switch to name VC
                API.createAccount { json in
                    Helper.switchRootView("NameVC")
                }
            }
        }
    }
}
