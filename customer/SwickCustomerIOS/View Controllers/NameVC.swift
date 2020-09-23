//
//  NameVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 9/23/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class NameVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If name is already already set, switch to tab bar VC
        if (UserDefaults.standard.bool(forKey: "nameSet")) {
            Helper.switchRootView("TabBarVC")
            return
        }
        
        // Make keyboard appear
        nameTextField.becomeFirstResponder()
    }
}

extension NameVC: UITextFieldDelegate {
    
    // When done button on keyboard is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = textField.text ?? ""
        if name == "" {
            Helper.alertError(self, "Please enter a name.")
            return true
        }
        API.updateUserInfo(name, "") { json in
            // If name successfully updated, switch to tab bar VC
            if (json["status"] == "success") {
                UserDefaults.standard.set(true, forKey: "nameSet")
                Helper.switchRootView("TabBarVC")
            }
            else {
                Helper.alertError(self)
            }
        }
        return true
    }
}
