//
//  AccountDetailsVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 9/23/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class AccountDetailsVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    @IBAction func save(_ sender: Any) {
        let name = self.nameTextField.text ?? ""
        let email = self.emailTextField.text ?? ""
        // Check if name is valid
        if name == "" {
            Helper.alert(self, message: "Name cannot be empty.")
            return
        }
        // Check if email is valid
        if !Helper.isValidEmail(email) {
            Helper.alert(self, message: "Invalid email. Please try again.")
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
                Helper.alert(self, message: "Email already taken. Please try a different email.")
            }
            else {
                Helper.alert(self, message: "Failed to update info. Please restart app and try again.")
            }
        }
    }
    
    // Load user info view from API call
    func loadUserInfo() {
        API.getUserInfo{ json in
            if json["status"] == "success" {
                self.nameTextField.text = json["name"].string
                self.emailTextField.text = json["email"].string
                self.restaurantLabel.text = json["restaurant_name"].string
            }
            else {
                Helper.alert(self, message: "Failed to get account info. Please restart app and try again.")
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
