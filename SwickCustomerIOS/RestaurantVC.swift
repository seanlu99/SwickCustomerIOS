//
//  RestaurantVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/12/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class RestaurantVC: UIViewController {
    
    // Array of all restaurants
    var restaurants = [Restaurant]()
    // Array of searched restaurants
    var searchedRestaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        APIManager.shared.getRestaurants { (json) in
            print(json)
        }
    }
}

extension RestaurantVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
            return cell
    }
}
