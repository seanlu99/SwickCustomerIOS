//
//  AccountVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/12/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    // Load user info view from API call
    func loadUserInfo() {
        API.getUserInfo { json in
            if (json["status"] == "success") {
                self.nameLabel.text = json["name"].string
                self.emailLabel.text = json["email"].string
                self.restaurantLabel.text = json["restaurant_name"].string
            }
            else {
                Helper.alertError(self, "Failed to get account info. Please restart app and try again.")
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        Helper.switchToLogin()
    }
}

