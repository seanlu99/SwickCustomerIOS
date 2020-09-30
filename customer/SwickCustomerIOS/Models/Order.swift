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
    var id: Int
    var restaurantName: String
    var time: Date
    var status: String
    
    init(json: JSON) {
        self.id = json["id"].int ?? -1
        self.restaurantName = json["restaurant"].string ?? ""
        self.time = Helper.convertStringToDate(json["order_time"].string ?? "")
        self.status = json["status"].string ?? ""
    }
}

class OrderDetails {
    var total: Double
    var items = [OrderItem]()
    
    init() {
        total = 0
    }
    
    init(json: JSON) {
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
    var status: String
    var customizations: [OrderItemCustomization] = []
    
    init(json: JSON) {
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
    }
    
    // Return customizations as a formatted string
    func getCustomizationString() -> String {
        var str = ""
        for cust in customizations {
            str += cust.name + "\n"
            for opt in cust.options {
                str += "- " + opt + "\n"
            }
        }
        // If customizations present, remove last new line
        if str != "" {
            str.remove(at: str.index(before: str.endIndex))
        }
        // Otherwise use a blank line
        else {
            str = " "
        }
        return str
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
