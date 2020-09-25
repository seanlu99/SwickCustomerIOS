//
//  AccountVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit
//remove this and next line
import SwiftyJSON
import Stripe

class AccountVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        //mock_calls()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    // Load user info view from API call
    func loadUserInfo() {
        API.getUserInfo{ json in
            if (json["status"] == "success") {
                self.nameLabel.text = json["name"].string
                self.emailLabel.text = json["email"].string
            }
            else {
                Helper.alert(self, message: "Failed to get account info. Please restart app and try again.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AccountToPaymentMethods" {
            let paymentMethodsVC = segue.destination as! PaymentMethodsVC
            paymentMethodsVC.previousView = "AccountVC"
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        Helper.switchToLogin()
    }
    
    @IBAction func manageCards(_ sender: Any) {
        self.performSegue(withIdentifier: "AccountToPaymentMethods", sender: self)
    }
}
