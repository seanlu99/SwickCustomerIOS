//
//  Request.swift
//  Server
//
//  Created by Sean Lu on 10/15/20.
//

import Foundation
import SwiftyJSON

struct OrderItemOrRequest: Identifiable {
    // O<order_id> for order
    // R<request_id> for request
    var id: String
    var table: String
    var name: String
    var customerName: String
    // Only for order items
    var orderId: Int?
    
    init(
        id: String,
        table: String,
        name: String,
        customerName: String,
        orderId: Int? = nil
    ) {
        self.id = id
        self.table = table
        self.name = name
        self.customerName = customerName
        self.orderId = orderId
    }
    
    init(_ json: JSON) {
        let idString = String(describing: json["id"].int ?? 0)
        // OrderItem
        if json["type"] == "OrderItem" {
            id = "O" + idString
            name = json["meal_name"].string ?? ""
            orderId = json["order_id"].int ?? 0
        }
        // Request
        else {
            id = "R" + idString
            name = json["request_name"].string ?? ""
            orderId = nil
        }
        table = String(describing: json["table"].int ?? 0)
        customerName = json["customer_name"].string ?? ""
    }
}
