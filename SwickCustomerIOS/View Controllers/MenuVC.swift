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
    let activityIndicator = UIActivityIndicatorView()
    
    // Restaurant clicked on in previous view
    var restaurant: Restaurant!
    // Array of all meals
    var menu = [Meal]()
    // Array of searched meals
    var searchedMenu = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation bar title to restaurant name
        self.title = restaurant.name!
        loadMeals()
    }
    
    // Load restaurant data from API call to table view
    func loadMeals() {
        // Show activity indicator while loading data
        Helper.showActivityIndicator(self.activityIndicator, view)
        
        APIManager.shared.getMenu(restaurantId: restaurant.id!){ (json) in
            self.menu = []
            // mealList = array of JSON meals
            if let mealList = json["menu"].array {
                // meal = a JSON meal
                for meal in mealList {
                    // m = meal object
                    let m = Meal(json: meal)
                    self.menu.append(m)
                }
            }
            
            // Reload table view after getting menu data from server
            self.tableView.reloadData()
            // Hide activity indicator when finished loading data
            Helper.hideActivityIndicator(self.activityIndicator)
        }
    }
}

extension MenuVC: UISearchBarDelegate {
    
    // Update searched restaurants array when text is changed in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedMenu = self.menu.filter({ (m: Meal) -> Bool in
            // Compare Meal names with search text
            return m.name!.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        // Reload table view after search
        self.tableView.reloadData()
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
        
        cell.nameLabel.text = meal.name!
        cell.descriptionLabel.text = meal.description!
        cell.priceLabel.text = Helper.formatPrice(meal.price!)
        if let imageString = meal.image {
            Helper.loadImage(cell.mealImage, "\(imageString)")
        }
        
        return cell
    }
}
