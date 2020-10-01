//
//  ToSendVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 9/30/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class ToSendVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // Label for no restaurant set
    let noRestaurantLabel = UILabel()
    
    // Array of all order items
    var items = [OrderItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.addNoRestaurantLabel(self.view, noRestaurantLabel)
        loadOrderItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadOrderItems()
    }
    
    @IBAction func refresh(_ sender: Any) {
        loadOrderItems()
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        let orderItemId = items[sender.tag].id
        API.updateOrderItemStatus(orderItemId, "COMPLETE") { json in
            if (json["status"] == "success") {
                // Reload table view after updating order
                self.loadOrderItems()
                self.tableView.reloadData()
            }
            else {
                Helper.alert(self, message: "Failed to update order. Please restart app and try again.")
            }
        }
    }
    // Load restaurant data from API call to table view
    func loadOrderItems() {
        API.getOrderItemsToSend { json in
            if (json["status"] == "success") {
                self.items = []
                // itemsList = array of JSON order items
                let itemsList = json["order_items"].array ?? []
                // item = a JSON order item
                for item in itemsList {
                    // i = order item object
                    let i = OrderItem(json: item)
                    self.items.append(i)
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
    
    // Retrieve and send order to order details VC when "see full order" action is clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSendToOrderDetails" {
            let orderDetailsVC = segue.destination as! OrderDetailsVC
            orderDetailsVC.orderId = items[(tableView.indexPathForSelectedRow?.row) ?? 0].orderId
        }
    }
}

extension ToSendVC: UITableViewDelegate, UITableViewDataSource {
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToSendCell", for: indexPath) as! ToSendCell
        let item = items[indexPath.row]
        cell.tableLabel.text = item.table
        cell.customerLabel.text = item.customer
        cell.mealNameLabel.text = item.mealName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Make grey row selection disappear
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Present options
        let orderItemId = items[indexPath.row].id
        OrderOptions.presentSendAlert(self, orderItemId, true) {
            self.loadOrderItems()
        }
    }
}
