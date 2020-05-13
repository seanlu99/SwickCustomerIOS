//
//  MenuVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/12/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {

    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        return cell
    }
}
