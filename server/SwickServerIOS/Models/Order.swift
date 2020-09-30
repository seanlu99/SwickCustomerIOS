//
//  Order.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class Order {
    var id: Int
    var customer: String
    var time: Date
    var status: String
    
    init(json: JSON) {
        self.id = json["id"].int ?? -1
        self.customer = json["customer"].string ?? ""
        self.time = Helper.convertStringToDate(json["order_time"].string ?? "")
        self.status = json["status"].string ?? ""
    }
}

class OrderDetails {
    var table: String
    var total: Double
    var items = [OrderItem]()
    
    init() {
        table = ""
        total = 0
    }
    
    init(json: JSON) {
        self.table = String(describing: json["table"].int ?? 0)
        let t = json["total"].string ?? ""
        self.total = Double(t) ?? 0
        
        // Extract order items from json
        let itemsList = json["order_item"].array ?? []
        for item in itemsList {
            let orderItem = OrderItem(json: item)
            self.items.append(orderItem)
        }
    }
}

class OrderItem {
    var id: Int
    var mealName: String
    var quantity: String
    var total: Double
    var status: String
    var customizations: [OrderItemCustomization] = []
    // Order fields
    var orderId: Int
    var table: String
    var customer: String
    
    init(json: JSON) {
        self.id = json["id"].int ?? -1
        self.mealName = json["meal_name"].string ?? ""
        self.quantity = String(describing: json["quantity"].int ?? 0)
        let t = json["total"].string ?? ""
        self.total = Double(t) ?? 0
        self.status = json["status"].string ?? ""
        
        // Extract customizations from json
        let customizationList = json["order_item_cust"].array ?? []
        for cust in customizationList {
            let custItem = OrderItemCustomization(json: cust)
            self.customizations.append(custItem)
        }
        
        self.orderId = json["order_id"].int ?? -1
        self.table = String(describing: json["table"].int ?? 0)
        self.customer = json["customer"].string ?? ""
    }
}

class OrderItemCustomization {
    var name: String
    var options: [String] = []
    
    init(json: JSON) {
        self.name = json["customization_name"].string ?? ""
        let optionsList = json["options"].array ?? []
        for opt in optionsList {
            options.append(opt.string ?? "")
        }
    }
}
