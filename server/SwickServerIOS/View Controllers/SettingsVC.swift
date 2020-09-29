//
//  AccountVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/12/20.
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Make grey row selection disappear
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

