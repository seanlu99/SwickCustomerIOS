//
//  CartVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit
import Stripe

class CartVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentTextField: STPPaymentCardTextField!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBAction func leaveRestaurant(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Leaving Restaurant", message: "Your cart will be lost", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            scannedRestaurant = false
            _ = self.navigationController?.popViewController(animated: true)
          }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    let activityIndicator = UIActivityIndicatorView()
    
    // Restaurant scanned in previous view
    var restaurant: Restaurant!
    // Table scanned in previous view
    var table: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable dynamic table view cell height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        toggleViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        toggleViews()
    }
    
    func toggleViews() {
        tableView.reloadData()
        // If there are no meals in cart
        if Cart.shared.items.count == 0 {
            totalLabel.isHidden = true
            totalPriceLabel.isHidden = true
            paymentLabel.isHidden = true
            paymentTextField.isHidden = true
            placeOrderButton.isHidden = true
            emptyLabel.isHidden = false
        }
        // If there are meals in cart
        else {
            totalLabel.isHidden = false
            totalPriceLabel.isHidden = false
            totalPriceLabel.text = Cart.shared.getTotal()
            paymentLabel.isHidden = false
            paymentTextField.isHidden = false
            placeOrderButton.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    // Send restaurant object to categories VC and set cameFromCart flag
    // to true when "Add items to cart" button is clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CartToCategory" {
            let categoryVC = segue.destination as! CategoryVC
            categoryVC.restaurant = restaurant
            categoryVC.cameFromCart = true
        }
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        // Set card parameters from payment text field
        let cardParams = STPCardParams()
        cardParams.number = self.paymentTextField.cardNumber
        cardParams.expMonth = self.paymentTextField.expirationMonth
        cardParams.expYear = self.paymentTextField.expirationYear
        cardParams.cvc = self.paymentTextField.cvc
        
        // Try to validate credit card from Stripe
        STPAPIClient.shared().createToken(withCard: cardParams) {(token, error) in
            // If Stripe error
            if (error != nil) {
                Helper.alert("Error", "Failed to validate card. Please try again", self)
            }
            // If card is validated
            else if let stripeToken = token?.tokenId {
                APIManager.shared.placeOrder(restaurantId: self.restaurant.id, table: self.table, stripeToken: stripeToken) { json in
                    if (json["status"] == "success") {
                        // Reset cart
                        Cart.shared.reset()
                        self.toggleViews()
                        
                        // Show alert with success
                        // "Go to orders" button segues to orders page
                        let alertView = UIAlertController(
                            title: "Success",
                            message: "Your order has been placed.",
                            preferredStyle: .alert
                        )
                        let goToOrders = UIAlertAction(title: "Go to orders", style: .default) { _ in
                            self.performSegue(withIdentifier: "unwindFromCartToOrder", sender: self)
                        }
                        alertView.addAction(goToOrders)
                        self.present(alertView, animated: true, completion: nil)
                    }
                    else {
                        Helper.alert("Error", "Failed to place order. Please try again.", self)
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToCart( _ seg: UIStoryboardSegue) { }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.items.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let cartItem = Cart.shared.items[indexPath.row]
        
        // Set labels
        cell.nameLabel.text = cartItem.meal.name
        cell.quantityLabel.text = String(cartItem.quantity)
        cell.totalLabel.text = Helper.formatPrice(cartItem.total)
        
        // Build customization label and set
        var custText = ""
        for cust in cartItem.customizations {
            var optionsText = ""
            for opt in cust.options {
                if opt.isChecked == true {
                    optionsText += "- " + opt.name + "\n"
                }
            }
            // Only add customization name if at least one option was checked
            if optionsText != "" {
                custText += cust.name + "\n" + optionsText
            }
        }
        // Remove last new line
        if custText != "" {
            custText.remove(at: custText.index(before: custText.endIndex))
        }
        cell.customizationLabel.text = custText
        
        return cell
    }
    
    // Delete cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Cart.shared.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Reload view
            viewDidAppear(true)
        }
    }
}
