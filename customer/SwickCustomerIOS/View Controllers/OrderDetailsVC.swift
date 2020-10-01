//
//  OrderDetailsVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class OrderDetailsVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // ID of order clicked on in previous view
    var orderId: Int!
    // Order details from API call
    var orderDetails = OrderDetails(json: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOrderDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadOrderDetails()
    }
    
    // Reload when refresh button is clicked
    @IBAction func refresh(_ sender: Any) {
        loadOrderDetails()
    }
    
    func loadOrderDetails() {
        // Load order details from API call
        API.getOrderDetails(orderId) { json in
            if (json["status"] == "success") {
                self.orderDetails = OrderDetails(json: json["order_details"])
                // Set navigation bar title to restaurant name
                self.title = self.orderDetails.restaurant
                self.timeLabel.text = Helper.convertDateToString(self.orderDetails.time)
                self.totalLabel.text = Helper.formatPrice(self.orderDetails.total)
                // Reload table view after getting order details data from server
                self.tableView.reloadData()
            }
            else {
                Helper.alert(self, message: "Failed to get order details. Please click refresh to try again.")
            }
        }
    }
}

extension OrderDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetails.items.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCell", for: indexPath) as! OrderDetailsCell
        let orderItem = orderDetails.items[indexPath.row]
        
        // Set labels
        cell.statusLabel.text = orderItem.status
        cell.mealNameLabel.text = orderItem.mealName
        cell.quantityLabel.text = orderItem.quantity
        cell.totalLabel.text = Helper.formatPrice(orderItem.total)
        cell.customizationLabel.text = orderItem.getCustomizationString()
        
        return cell
    }
}
