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
    var id: Int!
    var restaurantName: String!
    var status: String!
    var time: String!
    
    init(json: JSON) {
        self.id = json["id"].int
        self.restaurantName = json["restaurant"]["name"].string
        self.status = json["status"].string
        self.time = json["order_time"].string
    }
}

class OrderDetails {
    var status = ""
    var serverName = ""
    var total: Double = 0
    var table = ""
    var items = [OrderItem]()
    
    init() {}
    
    init(json: JSON) {
        self.status = json["status"].string!
        self.serverName = json["server"]["name"].string ?? ""
        let t = json["total"].string!
        self.total = Double(t)!
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
    var customizations: [OrderItemCustomization] = []
    
    init(json: JSON) {
        self.mealName = json["meal_name"].string
        self.quantity = String(describing: json["quantity"].int!)
        let t = json["total"].string!
        self.total = Double(t)
        
        // Extract customizations from json
        let customizationList = json["order_item_cust"].array!
        for cust in customizationList {
            let custItem = OrderItemCustomization(json: cust)
            self.customizations.append(custItem)
        }
    }
}

class OrderItemCustomization {
    var name: String!
    var options: [String] = []
    
    init(json: JSON) {
        self.name = json["customization_name"].string
        let optionsList = json["options"].array!
        for opt in optionsList {
            options.append(opt.string!)
        }
    }
}
