//
//  OrderItem.swift
//  Swick
//
//  Created by Sean Lu on 10/9/20.
//

import Foundation
import SwiftyJSON

struct OrderItem: Identifiable, Comparable {
    var id: Int
    var mealName: String
    var quantity: Int
    var total: Decimal
    var status: String
    var customizations = [Customization]()
    #if SERVER
    var orderId: Int
    var table: String
    #endif
    
    init(
        id: Int,
        mealName: String,
        quantity: Int,
        total: Decimal = 0,
        status: String = "",
        customizations: [Customization],
        orderId: Int = 0,
        table: String = ""
    ) {
        self.id = id
        self.mealName = mealName
        self.quantity = quantity
        self.total = total
        self.status = status
        self.customizations = customizations
        #if SERVER
        self.orderId = orderId
        self.table = table
        #endif
    }
    
    init(_ json: JSON) {
        id = json["id"].int ?? 0
        mealName = json["meal_name"].string ?? ""
        quantity = json["quantity"].int ?? 0
        let totalString = json["total"].string ?? ""
        total = Decimal(string: totalString) ?? 0
        status = json["status"].string ?? ""
        let customizationJsonList = json["order_item_cust"].array ?? []
        for customizationJson in customizationJsonList {
            self.customizations.append(Customization(customizationJson))
        }
        #if SERVER
        orderId = json["order_id"].int ?? 0
        table = String(describing: json["table"].int ?? 0)
        #endif
    }
    
    static func < (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.id == rhs.id
    }
}
