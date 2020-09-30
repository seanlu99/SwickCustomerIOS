//
//  ToCookVC.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 9/29/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class ToCookVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Array of all order items
    var items = [OrderItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadOrderItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadOrderItems()
    }
    
    @IBAction func refresh(_ sender: Any) {
        loadOrderItems()
    }
    
    @IBAction func cookButtonClicked(_ sender: UIButton) {
        let orderItemId = items[sender.tag].id
        API.updateOrderItemStatus(orderItemId, "SENDING") { json in
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
        API.getOrderItemsToCook { json in
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
            }
            else {
                Helper.alert(self, message: "Failed to get orders. Please click refresh to try again.")
            }
        }
    }
}

extension ToCookVC: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToCookCell", for: indexPath) as! ToCookCell
        let item = items[indexPath.row]
        cell.tableLabel.text = item.table
        cell.quantityLabel.text = item.quantity
        cell.mealNameLabel.text = item.mealName
        cell.customizationsLabel.text = Helper.buildCustomizationsString(item.customizations)
        // Save row in button
        cell.cookButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Make grey row selection disappear
        tableView.deselectRow(at: indexPath, animated: true)
    }
}