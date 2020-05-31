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
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    // Load user info view from API call
    func loadUserInfo() {
        // Show activity indicator while loading data
        Helper.showActivityIndicator(self.activityIndicator, view)
        
        APIManager.shared.getUserInfo{ json in
            if (json["status"] == "success") {
                self.nameLabel.text = json["name"].string
                self.emailLabel.text = json["email"].string
            }
            else {
                Helper.alert("Error", "Failed to get account info. Please restart app and try again.", self)
            }
        }
        
        // Hide activity indicator when finished loading data
        Helper.hideActivityIndicator(self.activityIndicator)
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
