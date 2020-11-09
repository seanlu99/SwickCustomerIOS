//
//  Order.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import Foundation
import SwiftyJSON

struct Order: Identifiable {
    var id: Int
    var restaurantName: String
    var customerName: String
    var table: String
    var time: Date
    var status: String
    var subtotal: Decimal
    var tax: Decimal
    var tip: Decimal?
    var total: Decimal
    
    init() {
        restaurantName = ""
        customerName = ""
        table = ""
        id = 0
        time = Date()
        status = ""
        subtotal = 0
        tax = 0
        tip = nil
        total = 0
    }
    
    init(
        id: Int,
        restaurantName: String = "",
        customerName: String = "",
        table: String = "",
        time: Date,
        status: String = "",
        subtotal: Decimal = 0,
        tax: Decimal = 0,
        tip: Decimal? = nil,
        total: Decimal = 0
    ) {
        self.id = id
        self.restaurantName = restaurantName
        self.customerName = customerName
        self.table = table
        self.time = time
        self.status = status
        self.subtotal = subtotal
        self.tip = tip
        self.tax = tax
        self.total = total
    }
    
    init(_ json: JSON) {
        id = json["id"].int ?? 0
        restaurantName = json["restaurant_name"].string ?? ""
        customerName = json["customer_name"].string ?? ""
        table = String(describing: json["table"].int ?? 0)
        time = Helper.convertStringToDate(json["order_time"].string ?? "")
        status = json["status"].string ?? ""
        let subtotalString = json["subtotal"].string ?? ""
        let taxString = json["tax"].string ?? ""
        let tipString = json["tip"].string ?? ""
        let totalString = json["total"].string ?? ""
        subtotal = Decimal(string: subtotalString) ?? 0
        tax = Decimal(string: taxString) ?? 0
        tip = Decimal(string: tipString)
        total = Decimal(string: totalString) ?? 0
    }
}
