//
//  RestaurantVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/12/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class RestaurantVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    
    // Array of all restaurants
    var restaurants = [Restaurant]()
    // Array of searched restaurants
    var searchedRestaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRestaurants()
    }
    
    // Load restaurant data from API call to table view
    func loadRestaurants() {
        // Show activity indicator while loading data
        Helper.showActivityIndicator(self.activityIndicator, view)
        
        APIManager.shared.getRestaurants{ json in
            if (json["status"] == "success") {
                self.restaurants = []
                // restlist = array of JSON restaurants
                let restList = json["restaurants"].array ?? []
                // rest = a JSON restaurant
                for rest in restList {
                    // restaurant = restaurant object
                    let restaurant = Restaurant(json: rest)
                    self.restaurants.append(restaurant)
                }
                // Reload table view after getting restaurants data from server
                self.tableView.reloadData()
            }
            else {
                Helper.alert("Error", "Failed to get restaurants. Please restart app and try again.", self)
            }
            // Hide activity indicator when finished loading data
            Helper.hideActivityIndicator(self.activityIndicator)
        }
    }
    
    // Send restaurant object to menu VC when a restaurant is clicked on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantToMenu" {
            let menuVC = segue.destination as! MenuVC
            // If search bar is being used
            if searchBar.text != "" {
                menuVC.restaurant = searchedRestaurants[(tableView.indexPathForSelectedRow?.row) ?? 0]
            }
            // If search bar is not being used
            else {
                menuVC.restaurant = restaurants[(tableView.indexPathForSelectedRow?.row) ?? 0]
            }
            
        }
    }
}

extension RestaurantVC: UISearchBarDelegate {
    
    // Update searched restaurants array when text is changed in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedRestaurants = self.restaurants.filter({ (rest: Restaurant) -> Bool in
            // Compare restaurant names with search text
            return rest.name.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        // Reload table view after search
        self.tableView.reloadData()
    }
}

extension RestaurantVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If search bar is being used
        if searchBar.text != "" {
            return self.searchedRestaurants.count
        }
        // If search bar is not being used
        return self.restaurants.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let restaurant: Restaurant
            
        // If search bar is being used
        if searchBar.text != "" {
            restaurant = searchedRestaurants[indexPath.row]
        }
        // If search bar is not being used
        else {
            restaurant = restaurants[indexPath.row]
        }
        
        cell.nameLabel.text = restaurant.name
        cell.addressLabel.text = restaurant.address
        Helper.loadImage(cell.restaurantImage, "\(restaurant.image)")
        
        return cell
    }
}
