//
//  MenuVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/12/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // Restaurant clicked on two views ago
    var restaurant: Restaurant!
    // Category clicked on in previous view
    var category: String!
    // If this view was derived from cart VC
    var cameFromCart = false
    // Array of all meals
    var menu = [Meal]()
    // Array of searched meals
    var searchedMenu = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation bar title to restaurant name
        self.title = category
        // Hide cart button if view derived from home
        if (!cameFromCart) {
            self.navigationItem.rightBarButtonItem = nil
        }
        loadMeals()
    }
    
    // Load restaurant data from API call to table view
    func loadMeals() {
        APIManager.shared.getMenu(restaurantId: restaurant.id, category: category) { json in
            if (json["status"] == "success") {
                self.menu = []
                // mealList = array of JSON meals
                let mealList = json["menu"].array ?? []
                // meal = a JSON meal
                for meal in mealList {
                    // m = meal object
                    let m = Meal(json: meal)
                    self.menu.append(m)
                }
                // Reload table view after getting menu data from server
                self.tableView.reloadData()
            }
            else {
                Helper.alert("Error", "Failed to get menu. Please restart app and try again.", self)
            }
        }
    }
    
    // Send restaurant and meal objects to meal VC when a meal is clicked on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuToMeal" {
            let mealVC = segue.destination as! MealVC
            // If search bar is being used
            if searchBar.text != "" {
                mealVC.meal = searchedMenu[(tableView.indexPathForSelectedRow?.row) ?? 0]
            }
            // If search bar is not being used
            else {
                mealVC.meal = menu[(tableView.indexPathForSelectedRow?.row) ?? 0]
            }
        }
    }
    
    @IBAction func unwindToMenu( _ seg: UIStoryboardSegue) { }
}

extension MenuVC: UISearchBarDelegate {
    
    // Update searched restaurants array when text is changed in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedMenu = self.menu.filter({ (m: Meal) -> Bool in
            // Compare Meal names with search text
            return m.name.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        // Reload table view after search
        self.tableView.reloadData()
    }
    
    // Close keyboard when search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If search bar is being used
        if searchBar.text != "" {
            return self.searchedMenu.count
        }
        // If search bar is not being used
        return self.menu.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let meal: Meal
            
        // If search bar is being used
        if searchBar.text != "" {
            meal = searchedMenu[indexPath.row]
        }
        // If search bar is not being used
        else {
            meal = menu[indexPath.row]
        }
        
        cell.nameLabel.text = meal.name
        cell.descriptionLabel.text = meal.description
        cell.priceLabel.text = Helper.formatPrice(meal.price)
        Helper.loadImage(cell.mealImage, "\(meal.image)")
        
        return cell
    }
    
    // On cell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (cameFromCart) {
            self.performSegue(withIdentifier: "MenuToMeal", sender: self)
        }
    }
}
