//
//  AccountVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        Helper.switchRootView("LoginNC")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsToPaymentMethods" {
            let paymentMethodsVC = segue.destination as! PaymentMethodsVC
            paymentMethodsVC.previousView = "SettingsVC"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Make grey row selection disappear
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
