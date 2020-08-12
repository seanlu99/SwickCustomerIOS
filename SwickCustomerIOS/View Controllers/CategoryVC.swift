//
//  CategoryVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/31/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    
    // Restaurant clicked on in previous view
    var restaurant: Restaurant!
    // If the previous view was cart
    var cameFromCart = false
    // Array of all categories
    var categories = [String]()
    // Array of searched categories
    var searchedCategories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation bar title to restaurant name
        self.title = restaurant.name
        loadCategories()
    }
    
    // Load categories data from API call to table view
    func loadCategories() {
        // Show activity indicator while loading data
        Helper.showActivityIndicator(self.activityIndicator, view)
        
        APIManager.shared.getCategories(restaurantId: restaurant.id) { json in
            if (json["status"] == "success") {
                self.categories = ["All"]
                // mealList = array of JSON meal
                let mealList = json["categories"].array ?? []
                // meal = a JSON meal
                for meal in mealList {
                    let c = meal["category"].string ?? ""
                    self.categories.append(c)
                }
                // Reload table view after getting category data from server
                self.tableView.reloadData()
            }
            else {
                Helper.alert("Error", "Failed to get categories. Please restart app and try again.", self)
            }
            // Hide activity indicator when finished loading data
            Helper.hideActivityIndicator(self.activityIndicator)
        }
    }
    
    // Send restaurant object, category string and cameFromCart flag
    // to menu VC when a category is clicked on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryToMenu" {
            let menuVC = segue.destination as! MenuVC
            menuVC.restaurant = restaurant
            menuVC.cameFromCart = cameFromCart
            // If search bar is being used
            if searchBar.text != "" {
                menuVC.category = searchedCategories[(tableView.indexPathForSelectedRow?.row) ?? 0]
            }
            // If search bar is not being used
            else {
                menuVC.category = categories[(tableView.indexPathForSelectedRow?.row) ?? 0]
            }
        }
    }
}

extension CategoryVC: UISearchBarDelegate {
    
    // Update searched categories array when text is changed in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCategories = self.categories.filter({ (c: String) -> Bool in
            // Compare categories with search text
            return c.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        // Reload table view after search
        self.tableView.reloadData()
    }
    
    // Close keyboard when search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If search bar is being used
        if searchBar.text != "" {
            return self.searchedCategories.count
        }
        // If search bar is not being used
        return self.categories.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category: String
            
        // If search bar is being used
        if searchBar.text != "" {
            category = searchedCategories[indexPath.row]
        }
        // If search bar is not being used
        else {
            category = categories[indexPath.row]
        }
        cell.name.text = category
        
        return cell
    }
}

