//
//  OrderVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    // Label for no restaurant set
    var noRestaurantLabel = UILabel()
    
    // Array of all orders
    var orders = [Order]()
    
    override func viewDidLoad() {
        // Set title based on navigation controller
        if (self.navigationController is CookNC) {
            self.title = "To Cook"
        }
        else if (self.navigationController is SendNC) {
            self.title = "To Send"
        }
        else {
            self.title = "Done"
        }
        
        // Create no restaurant label
        noRestaurantLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        noRestaurantLabel.center = self.view.center
        noRestaurantLabel.textAlignment = NSTextAlignment.center
        noRestaurantLabel.text = "Your restaurant must add you as a server"
        noRestaurantLabel.isHidden = true
        self.view.addSubview(noRestaurantLabel)
        
        super.viewDidLoad()
        loadOrders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadOrders()
    }
    
    // Reload when refresh button is clicked
    @IBAction func refresh(_ sender: Any) {
        loadOrders()
    }
    
    // Load restaurant data from API call to table view
    func loadOrders() {
        // Get orders based on navigation controller/status
        var status = 3
        if (self.navigationController is CookNC) {
            status = 1
        }
        else if (self.navigationController is SendNC) {
            status = 2
        }
        
        APIManager.shared.getOrders(status: status) { json in
            if (json["status"] == "success") {
                self.orders = []
                // orderList = array of JSON orders
                let orderList = json["orders"].array ?? []
                // order = a JSON order
                for order in orderList {
                    // o = order object
                    let o = Order(json: order)
                    self.orders.append(o)
                }
                // Reload table view after getting order data from server
                self.tableView.reloadData()
                
                // Display table view and hide no restaurant label
                self.tableView.isHidden = false
                self.noRestaurantLabel.isHidden = true
            }
            else if (json["status"] == "restaurant_not_set") {
                // Hide table view and display no restaurant label
                self.tableView.isHidden = true
                self.noRestaurantLabel.isHidden = false
            }
            else {
                Helper.alert("Error", "Failed to get orders. Please click refresh to try again.", self)
            }
        }
    }
    
    @IBAction func checkboxClicked(_ sender: Checkbox) {
        let orderId = orders[sender.row ?? 0].id
        
        // Change order status based on navigation controller
        var status = 3
        if (self.navigationController is CookNC) {
            status = 2
        }
        
        APIManager.shared.updateOrderStatus(orderId: orderId, status: status) { json in
            if (json["status"] == "success") {
                // Reload table view after updating order
                self.loadOrders()
                self.tableView.reloadData()
            }
            else {
                Helper.alert("Error", "Failed to update order. Please restart app and try again.", self)
            }
        }
    }
    
    // Send order id to order details VC when an order is clicked on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderToOrderDetails" {
            let orderDetailsVC = segue.destination as! OrderDetailsVC
            orderDetailsVC.order = orders[(tableView.indexPathForSelectedRow?.row) ?? 0]
        }
    }
}

extension OrderVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order = orders[indexPath.row]
        cell.customerNameLabel.text = order.customerName
        cell.tableLabel.text = order.table
        cell.timeLabel.text = order.time
        cell.checkbox.row = indexPath.row
        
        
        // Display checkbox based on navigation controller
        if (self.navigationController is CookNC) {
            cell.checkbox.displayCook()
        }
        else if (self.navigationController is SendNC) {
            cell.checkbox.displaySend()
        }
        else {
            cell.checkbox.isHidden = true
        }
        
        return cell
    }
}
