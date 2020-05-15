//
//  AccountVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class AccountVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    // Load user info view from API call
    func loadUserInfo() {
        APIManager.shared.getUserInfo{ json in
            self.nameLabel.text = json["name"].string
            self.emailLabel.text = json["email"].string
        }
    }
    
    // When logout button is clicked
    @IBAction func fbLogout(_ sender: Any) {
        // Revoke Django access token from server
        // Then logout with FB Login Manager
        // Then switch root view
        APIManager.shared.revokeToken{
            LoginManager().logOut()
            self.switchRootView()
        }
    }
    
    // Switch root view to login VC
    func switchRootView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
}
