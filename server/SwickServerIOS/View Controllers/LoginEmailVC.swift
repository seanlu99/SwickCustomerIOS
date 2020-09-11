//
//  LoginEmailVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 9/11/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

import SwiftyJSON

class LoginEmailVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make keyboard appear
        emailTextField.becomeFirstResponder()
    }
    
    // Send email to LoginCodeVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmailToCode" {
            let loginCodeVC = segue.destination as! LoginCodeVC
            loginCodeVC.email = emailTextField.text ?? ""
        }
    }
}

extension LoginEmailVC: UITextFieldDelegate {
    
    // When send button on keyboard is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = textField.text ?? ""
        
        // Check if email is valid
        if Helper.isValidEmail(email) {
            self.performSegue(withIdentifier: "EmailToCode", sender: self)
            
            // Get verification code
            API.getVerificationCode(emailTextField.text ?? "") { json in
                let detail = json["detail"].string ?? ""
                
                // Alert error if email not send
                if detail != "A login token has been sent to your email." {
                    Helper.alertError(self, "Email could not be sent. Please try again.")
                }
            }
        }
        // Alert error if invalid email address
        else {
            Helper.alertError(self, "Invalid email. Please try again.")
        }
        return true
    }
}
