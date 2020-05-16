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
    
    // Meal clicked on in previous view
    var meal: Meal!
    // Initial quantity
    var quantity = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeal()
    }
    
    // Load meal into view with object from previous view
    func loadMeal() {
        totalLabel.text = Helper.formatPrice(meal.price)
        nameLabel.text = meal.name
        descriptionLabel.text = meal.description
        if let imageString = meal.image {
            Helper.loadImage(mealImage, "\(imageString)")
        }
    }
    
    @IBAction func subQuantity(_ sender: Any) {
        if quantity >= 2 {
            quantity -= 1
            quantityLabel.text = String(quantity)
            totalLabel.text = Helper.formatPrice(meal.price * Double(quantity))
        }
    }
    
    @IBAction func addQuantity(_ sender: Any) {
        if quantity < 99 {
            quantity += 1
            quantityLabel.text = String(quantity)
            totalLabel.text = Helper.formatPrice(meal.price * Double(quantity))
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        let cartItem = CartItem(meal, quantity)
        Cart.shared.items.append(cartItem)
    }
}
