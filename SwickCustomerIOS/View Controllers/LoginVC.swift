//
//  LoginVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit
import FBSDKLoginKit

// Add this to the body
class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // If user is already logged in
        // Switch root view
        if (AccessToken.current != nil) {
            switchRootView()
        }
    }
    
    // When Facebook login button is clicked
    @IBAction func fbLogin(_ sender: Any) {
        // If user is not logged in
        // Login with FB LoginManager
        // Then get Django access token from server
        // Then switch root view
        LoginManager().logIn(
            permissions: ["public_profile", "email"],
            from: self,
            handler: { (result, error) in
                if (error == nil && AccessToken.current != nil) {
                    APIManager.shared.getToken() {
                        self.switchRootView()
                    }
                }
        })
    }
    
    // Switch root view to tab bar controller
    func switchRootView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
}
