//
//  Order.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/15/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class Order {
    var restaurantName: String!
    var serverName: String!
    var status: String!
    var time: String!
    var total: Double!
    var table: String!
    var items = [OrderItem]()
    
    init(json: JSON) {
        self.restaurantName = json["restaurant"]["name"].string
        self.serverName = json["server"]["name"].string
        self.status = json["status"].string
        self.time = json["order_time"].string
        let t = json["total"].string!
        self.total = Double(t)
        self.table = String(describing: json["table"].int!)
        
        // Extract order items from json
        let itemsList = json["order_item"].array!
        for item in itemsList {
            let orderItem = OrderItem(json: item)
            self.items.append(orderItem)
        }
    }
}

class OrderItem {
    var mealName: String!
    var quantity: String!
    var total: Double!
    
    init(json: JSON) {
        self.mealName = json["meal"]["name"].string
        self.quantity = String(describing: json["quantity"].int!)
        let t = json["total"].string!
        self.total = Double(t)
    }
}
