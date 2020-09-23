//
//  AccountDetailsVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 9/23/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class AccountDetailsVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    @IBAction func save(_ sender: Any) {
        let name = self.nameTextField.text ?? ""
        let email = self.emailTextField.text ?? ""
        // Check if name is valid
        if name == "" {
            Helper.alertError(self, "Name cannot be empty.")
            return
        }
        // Check if email is valid
        if !Helper.isValidEmail(email) {
            Helper.alertError(self, "Invalid email. Please try again.")
            return
        }
        API.updateUserInfo(name, email) { json in
            if json["status"] == "success" {
                self.loadUserInfo()
                // Close keyboard
                self.nameTextField.resignFirstResponder()
                self.emailTextField.resignFirstResponder()
            }
            else if json["status"] == "email_already_taken" {
                Helper.alertError(self, "Email already taken. Please try a different email.")
            }
            else {
                Helper.alertError(self, "Failed to update info. Please restart app and try again.")
            }
        }
    }
    
    // Load user info view from API call
    func loadUserInfo() {
        API.getUserInfo{ json in
            if json["status"] == "success" {
                self.nameTextField.text = json["name"].string
                self.emailTextField.text = json["email"].string
            }
            else {
                Helper.alertError(self, "Failed to get account info. Please restart app and try again.")
            }
        }
    }
}

extension AccountDetailsVC : UITextFieldDelegate {
    
    // Close keyboard when return button is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
