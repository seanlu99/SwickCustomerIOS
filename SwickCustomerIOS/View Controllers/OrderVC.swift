//
//  OrdersTVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class OrderVC: UITableViewController {
    
    // Array of all orders
    var orders = [Order]()
    
    override func viewDidLoad() {
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
        APIManager.shared.getOrders { json in
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
            }
            else {
                Helper.alert("Error", "Failed to get orders. Please click refresh to try again.", self)
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
    
    // Unwind from cart VC to order VC
    @IBAction func unwindFromCart( _ seg: UIStoryboardSegue) { }
    
    // Set number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    // Properties for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order = orders[indexPath.row]
        cell.restaurantNameLabel.text = order.restaurantName
        cell.timeLabel.text = order.time
        cell.statusLabel.text = order.status
        return cell
    }
}
