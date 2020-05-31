//
//  CartVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a label saying cart is empty
        emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        emptyLabel.center = self.view.center
        emptyLabel.textAlignment = NSTextAlignment.center
        emptyLabel.text = "Your cart is empty"
        self.view.addSubview(emptyLabel)
        
        // Enable dynamic table view cell height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // If there are no meals in tray
        if Cart.shared.items.count == 0 {
            // Hide views
            tableView.isHidden = true
            bottomView.isHidden = true
            // Show empty label
            emptyLabel.isHidden = false
        }
            
        // If there are meals in tray
        else {
            // Show views
            tableView.isHidden = false
            bottomView.isHidden = false
            tableView.reloadData()
            totalLabel.text = Cart.shared.getTotal()
            // Hide empty label
            emptyLabel.isHidden = true
        }
    }
    
    @IBAction func addPayment(_ sender: Any) {
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        APIManager.shared.placeOrder { json in
            if (json["status"] == "success") {
                // Reset cart
                Cart.shared.reset()
                
                // Show alert with success
                // "Go to orders" button segues to orders page
                let alertView = UIAlertController(
                    title: "Success",
                    message: "Your order has been placed.",
                    preferredStyle: .alert
                )
                let goToOrders = UIAlertAction(title: "Go to orders", style: .default) { _ in
                    self.performSegue(withIdentifier: "unwindToOrder", sender: self)
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
