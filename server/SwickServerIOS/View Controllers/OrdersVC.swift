//
//  OrderVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class OrdersVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    // Label for no restaurant set
    let noRestaurantLabel = UILabel()
    
    // Array of all orders
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.addNoRestaurantLabel(self.view, noRestaurantLabel)
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
        
        API.getOrders { json in
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
                Helper.alert(self, message: "Failed to get orders. Please click refresh to try again.")
            }
        }
    }
    
    // Send order to order details VC when an order is clicked on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderToOrderDetails" {
            let orderDetailsVC = segue.destination as! OrderDetailsVC
            orderDetailsVC.orderId = orders[(tableView.indexPathForSelectedRow?.row) ?? 0].id
        }
    }
}

extension OrdersVC: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.customerNameLabel.text = order.customer
        cell.timeLabel.text = Helper.convertDateToString(order.time)
        cell.statusLabel.text = order.status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Make grey row selection disappear
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
