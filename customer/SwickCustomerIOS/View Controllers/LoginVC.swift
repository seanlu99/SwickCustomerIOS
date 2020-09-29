//
//  LoginVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If user is already logged in, switch to name VC
        if (UserDefaults.standard.string(forKey: "token") != nil) {
            Helper.switchRootView("NameVC")
        }
        
        // Set navigation bar color and make border disappear
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = Helper.hexColor(0xBAD9F5)
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
    }
}
