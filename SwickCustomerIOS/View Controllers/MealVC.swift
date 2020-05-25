//
//  MealVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class MealVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView()
    
    // Meal clicked on in previous view
    var meal: Meal!
    // Array of all customizations
    var customizations = [Customization]()
    // Meal price with customizations
    var adjustedPrice: Double!
    // Initial quantity
    var quantity = 1
    // Adjusted price * quantity
    var total: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustedPrice = meal.price
        loadMeal()
    }
    
    func loadMeal() {
        // Show activity indicator while loading data
        Helper.showActivityIndicator(self.activityIndicator, view)
        
        // Load meal into view with object from previous view
        nameLabel.text = meal.name
        descriptionLabel.text = meal.description
        if let imageString = meal.image {
            Helper.loadImage(mealImage, "\(imageString)")
        }
        updateTotal()
        
        // Load customizations of meal from API call
        APIManager.shared.getMeal(mealId: meal.id!) { json in
            self.customizations = []
            // customizationList = array of JSON customizations
            let customizationList = json["customizations"].array!
            // customization = a JSON customization
            for customization in customizationList {
                // cust = customization object
                let cust = Customization(json: customization)
                self.customizations.append(cust)
            }
            
            // Reload table view after getting menu data from server
            self.tableView.reloadData()
            // Hide activity indicator when finished loading data
            Helper.hideActivityIndicator(self.activityIndicator)
        }
    }
    
    // Update total and total label
    func updateTotal() {
        total = adjustedPrice * Double(quantity)
        totalLabel.text = Helper.formatPrice(total)
    }
    
    // Set checkbox to reverse state
    // Add or remove price addition from adjusted price accordingly
    // Update total
    @IBAction func checkboxClicked(_ sender: Checkbox) {
        let option = customizations[sender.section].options[sender.row]
        if option.isChecked == true {
            option.isChecked = false
            sender.uncheck()
            adjustedPrice -= option.priceAddition
            
        }
        else {
            option.isChecked = true
            sender.check()
            adjustedPrice += option.priceAddition
        }
        updateTotal()
    }
    
    // Subtract 1 from quantity
    // Update total
    @IBAction func subQuantity(_ sender: Any) {
        if quantity >= 2 {
            quantity -= 1
            quantityLabel.text = String(quantity)
            updateTotal()
        }
    }
    
    // Add 1 to quantity
    // Update total
    @IBAction func addQuantity(_ sender: Any) {
        if quantity < 99 {
            quantity += 1
            quantityLabel.text = String(quantity)
            updateTotal()
        }
    }
    
    // Send item to cart
    @IBAction func addToCart(_ sender: Any) {
        let cartItem = CartItem(meal, quantity, total, customizations)
        Cart.shared.items.append(cartItem)
    }
}

extension MealVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return customizations.count
    }
    
    // Set section header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return customizations[section].name
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If search bar is not being used
        return customizations[section].options.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizationCell", for: indexPath) as! CustomizationCell
        let option = customizations[indexPath.section].options[indexPath.row]
        
        // Set option and price addition labels
        cell.optionLabel.text = option.name
        cell.additionLabel.text = "+" + Helper.formatPrice(option.priceAddition)
        
        // Store section and row of checkbox
        cell.checkbox.section = indexPath.section
        cell.checkbox.row = indexPath.row
        
        // Display checked or unchecked image accordingly
        if option.isChecked == true {
            cell.checkbox.check()
        }
        else {
            cell.checkbox.uncheck()
        }
        
        return cell
    }
}
