//
//  OrdersTVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class OrdersTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Set number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Set number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // Properties for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        return cell
    }
}
