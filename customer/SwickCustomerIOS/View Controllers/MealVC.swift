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
    
    // Meal clicked on in previous view
    var meal: Meal!
    // Array of all customizations
    var customizations = [Customization]()
    // Meal price with customizations
    var adjustedPrice: Double = 0
    // Initial quantity
    var quantity = 1
    // Adjusted price * quantity
    var total: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustedPrice = meal.price
        loadMeal()
    }
    
    func loadMeal() {
        // Load meal into view with object from previous view
        nameLabel.text = meal.name
        descriptionLabel.text = meal.description
        Helper.loadImage(mealImage, String(describing: meal.image))
        updateTotal()
        
        // Load customizations of meal from API call
        APIManager.shared.getMeal(mealId: meal.id) { json in
            if (json["status"] == "success") {
                self.customizations = []
                // customizationList = array of JSON customizations
                let customizationList = json["customizations"].array ?? []
                // customization = a JSON customization
                for customization in customizationList {
                    // cust = customization object
                    let cust = Customization(json: customization)
                    self.customizations.append(cust)
                }
                // Reload table view after getting meal data from server
                self.tableView.reloadData()
            }
            else {
                Helper.alert("Error", "Failed to get meal. Please restart app and try again.", self)
            }
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
        let cust = customizations[sender.section ?? 0]
        let option = cust.options[sender.row ?? 0]
        // Check
        if option.isChecked == false {
            if cust.numChecked < cust.max {
                option.isChecked = true
                sender.check()
                adjustedPrice += option.priceAddition
                cust.numChecked += 1
            }
        }
        // Uncheck
        else {
            option.isChecked = false
            sender.uncheck()
            adjustedPrice -= option.priceAddition
            cust.numChecked -= 1
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
        var minimumSelected = true
        for cust in customizations {
            if cust.numChecked < cust.min {
                minimumSelected = false
                break
            }
        }
        
        // If minimum customizations selected
        if minimumSelected {
            let cartItem = CartItem(meal, quantity, total, customizations)
            Cart.shared.items.append(cartItem)
            performSegue(withIdentifier: "unwindFromMealToMenu", sender: self)
        }
        
        // If minimum customizations not selected
        else {
            Helper.alert("Error", "Please select mininum number of options.", self)
        }
    }
}

extension MealVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return customizations.count
    }
    
    // Set section header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Section view
        let screenWidth = UIScreen.main.bounds.width
        let sectionView = UIView()
        sectionView.backgroundColor = Helper.hexColor(0xBAD9F5)
        
        // Customization name label
        let customizationLabel = UILabel(frame: CGRect(x: 20, y: 10, width: screenWidth - 40, height: 17))
        customizationLabel.text = customizations[section].name
        sectionView.addSubview(customizationLabel)
        
        // Min max label
        let minMaxLabel = UILabel(frame: CGRect(x: 20, y: 35, width: screenWidth - 40, height: 15))
        minMaxLabel.text = "Min: " + String(customizations[section].min) + ", Max: " + String(customizations[section].max)
        minMaxLabel.font = minMaxLabel.font.withSize(15)
        sectionView.addSubview(minMaxLabel)
        
        return sectionView
    }
    
    // Set section header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
