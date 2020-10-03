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
    
    // Array of all order/request items
    var items = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.addNoRestaurantLabel(self.view, noRestaurantLabel)
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
    }
    
    @IBAction func refresh(_ sender: Any) {
        loadItems()
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        let item = items[sender.tag]
        // Update order item status if cell contains order item
        if item is OrderItem {
            let orderItem = item as! OrderItem
            API.updateOrderItemStatus(orderItem.id, "COMPLETE") { json in
                if (json["status"] == "success") {
                    // Reload table view after updating order
                    self.loadItems()
                }
                else {
                    Helper.alert(self, message: "Failed to update order. Please restart app and try again.")
                }
            }
        }
        // Delete request if cell contains request
        else if item is Request {
            let request = item as! Request
            deleteRequest(request.id)
        }
    }
    // Load restaurant data from API call to table view
    func loadItems() {
        API.getItemsToSend { json in
            if (json["status"] == "restaurant_not_set") {
                // Hide table view and display no restaurant label
                self.tableView.isHidden = true
                self.noRestaurantLabel.isHidden = false
            }
            else {
                self.items = []
                // itemsList = array of JSON items
                let itemsList = json.array ?? []
                // item = a JSON item
                for item in itemsList {
                    // Create order item
                    if item["type"] == "OrderItem" {
                        self.items.append(OrderItem(json: item))
                    }
                    // Create request
                    else if item["type"] == "Request" {
                        self.items.append(Request(json: item))
                    }
                }
                // Reload table view after getting data from server
                self.tableView.reloadData()
                
                // Display table view and hide no restaurant label
                self.tableView.isHidden = false
                self.noRestaurantLabel.isHidden = true
            }
        }
    }
    
    // Delete request
    func deleteRequest(_ id: Int) {
        API.deleteRequest(id) { json in
            if (json["status"] == "success") {
                self.loadItems()
            }
            else {
                Helper.alert(self)
            }
        }
    }
    
    // Retrieve and send order to order details VC when "see full order" action is clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSendToOrderDetails" {
            let orderDetailsVC = segue.destination as! OrderDetailsVC
            let orderItem = items[(tableView.indexPathForSelectedRow?.row) ?? 0] as! OrderItem
            orderDetailsVC.orderId = orderItem.orderId
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
        // If cell contains an order item
        if item is OrderItem {
            let orderItem = item as! OrderItem
            cell.tableLabel.text = orderItem.table
            cell.customerLabel.text = orderItem.customer
            cell.mealNameLabel.text = orderItem.mealName
        }
        // If cell contains a request
        else if item is Request {
            let request = item as! Request
            cell.tableLabel.text = request.table
            cell.customerLabel.text = request.customer
            cell.mealNameLabel.text = request.requestName
        }
        // Save row in button
        cell.sendButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Make grey row selection disappear
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        // Present order options for order item
        if item is OrderItem {
            let orderItem = item as! OrderItem
            OrderOptions.presentSendAlert(self, orderItem.id, true) {
                self.loadItems()
            }
        }
        // Present request options for request
        else if item is Request {
            let request = item as! Request
            let alertView = UIAlertController(
                title: "Request options",
                message: nil,
                preferredStyle: .alert
            )
            let sendAction = UIAlertAction(title: "Finish sending", style: .default) { _ in
                self.deleteRequest(request.id)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertView.addAction(sendAction)
            alertView.addAction(cancelAction)
            self.present(alertView, animated: true)
        }
    }
}
