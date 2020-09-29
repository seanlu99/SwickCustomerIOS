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
    var customerName: String
    var table: String
    var time: Date
    
    init(json: JSON) {
        self.id = json["id"].int ?? -1
        self.customerName = json["customer"]["name"].string ?? ""
        self.table = String(describing: json["table"].int ?? 0)
        self.time = Helper.convertStringToDate(json["order_time"].string ?? "")
    }
}

class OrderDetails {
    var chefName: String
    var serverName: String
    var total: Double
    var items = [OrderItem]()
    
    init() {
        chefName = ""
        serverName = ""
        total = 0
    }
    
    init(json: JSON) {
        self.chefName = json["chef"]["name"].string ?? ""
        self.serverName = json["server"]["name"].string ?? ""
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
    var mealName: String
    var quantity: String
    var total: Double
    var customizations: [OrderItemCustomization] = []
    
    init(json: JSON) {
        self.mealName = json["meal_name"].string ?? ""
        self.quantity = String(describing: json["quantity"].int ?? 0)
        let t = json["total"].string ?? ""
        self.total = Double(t) ?? 0
        
        // Extract customizations from json
        let customizationList = json["order_item_cust"].array ?? []
        for cust in customizationList {
            let custItem = OrderItemCustomization(json: cust)
            self.customizations.append(custItem)
        }
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
