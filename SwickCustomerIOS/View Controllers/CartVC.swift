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
            Cart.shared.reset()
            //self.performSegue(withIdentifier: "ViewOrder", sender: self)
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
        cell.nameLabel.text = cartItem.meal.name
        cell.quantityLabel.text = String(cartItem.quantity)
        cell.totalLabel.text = Helper.formatPrice(cartItem.meal.price * Double(cartItem.quantity))
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
