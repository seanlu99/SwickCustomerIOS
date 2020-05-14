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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // If user is already logged in
        // Switch root view
        if (AccessToken.current != nil) {
            switchRootView()
        }
    }
    
    // When Facebook login button is clicked
    @IBAction func fbLogin(_ sender: Any) {
        // If user already has Facebook access token
        // Get Django access token from server
        // Then switch root view
        if (AccessToken.current != nil) {
            APIManager.shared.login(completionHandler: { (error) in
                if error == nil {
                    self.switchRootView()
                }
            })
            
        }
        // If user does not have Facebook access token
        // Login with FB LoginManager
        // Then get FB user data
        // Then get Django access token from server
        // Then switch root view
        else {
            print("doesnt have fb access token")
            FBManager.shared.logIn(
                permissions: ["public_profile", "email"],
                from: self,
                handler: { (result, error) in
                    if (error == nil) {
                        FBManager.getFBUserData(completionHandler: {
                            APIManager.shared.login(completionHandler: { (error) in
                                if error == nil {
                                    self.switchRootView()
                                }
                            })
                        })
                    }
            })
        }
    }
    
    // Switch root view to tab bar controller
    func switchRootView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
}
