//
//  Request.swift
//  Server
//
//  Created by Sean Lu on 10/15/20.
//

import Foundation
import SwiftyJSON

struct OrderItemOrRequest: Identifiable, Comparable {
    // O<order_id> for order
    // R<request_id> for request
    var id: String
    var table: String
    var name: String
    var customerName: String
    // Only for order items
    var orderId: Int?
    var time: Date
    
    init(
        id: String,
        table: String,
        name: String,
        customerName: String,
        orderId: Int? = nil,
        time: Date
    ) {
        self.id = id
        self.table = table
        self.name = name
        self.customerName = customerName
        self.orderId = orderId
        self.time = time
    }
    
    init(_ json: JSON) {
        let idString = String(describing: json["id"].int ?? 0)
        if let mealName = json["meal_name"].string {
            id = "O" + idString
            name = mealName
            orderId = json["order_id"].int ?? 0
        }
        else {
            id = "R" + idString
            name = json["request_name"].string ?? ""
            orderId = nil
        }
        table = String(describing: json["table"].int ?? 0)
        customerName = json["customer_name"].string ?? ""
        time = Helper.convertStringToDate(json["time"].string ?? "")
    }
    
    static func < (lhs: OrderItemOrRequest, rhs: OrderItemOrRequest) -> Bool {
        let isLessThan = lhs.time != rhs.time ? lhs.time < rhs.time : lhs.id < rhs.id
        return isLessThan
    }
}
