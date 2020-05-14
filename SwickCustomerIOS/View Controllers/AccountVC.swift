//
//  AccountVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set user and email labels
        nameLabel.text = User.currentUser.name
        emailLabel.text = User.currentUser.email
    }
    
    // When logout button is clicked
    @IBAction func fbLogout(_ sender: Any) {
        // Revoke Django access token from server
        // Then logout with FB Login Manager
        // Then reset user data
        // Then switch root view
        APIManager.shared.logout(completionHandler: { (error) in
            if error == nil {
                FBManager.shared.logOut()
                User.currentUser.resetInfo()
                self.switchRootView()
            }
        })
    }
    
    // Switch root view to login VC
    func switchRootView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
}
