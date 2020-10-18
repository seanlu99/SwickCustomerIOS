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
    var time: Date
    var status: String
    var subtotal: Decimal
    var tax: Decimal
    var total: Decimal
    #if CUSTOMER
    var restaurantName: String
    #else
    var customerName: String
    var table: String
    #endif
    
    init() {
        id = 0
        time = Date()
        status = ""
        subtotal = 0
        tax = 0
        total = 0
        #if CUSTOMER
        restaurantName = ""
        #else
        customerName = ""
        table = ""
        #endif
    }
    
    init(
        id: Int,
        time: Date,
        status: String = "",
        subtotal: Decimal = 0,
        tax: Decimal = 0,
        total: Decimal = 0,
        restaurantName: String = "",
        customerName: String = "",
        table: String = ""
    ) {
        self.id = id
        self.time = time
        self.status = status
        self.subtotal = subtotal
        self.tax = tax
        self.total = total
        #if CUSTOMER
        self.restaurantName = restaurantName
        #else
        self.customerName = customerName
        self.table = table
        #endif
    }
    
    init(_ json: JSON) {
        id = json["id"].int ?? 0
        time = Helper.convertStringToDate(json["order_time"].string ?? "")
        status = json["status"].string ?? ""
        let subtotalString = json["subtotal"].string ?? ""
        let taxString = json["tax"].string ?? ""
        let totalString = json["total"].string ?? ""
        subtotal = Decimal(string: subtotalString) ?? 0
        tax = Decimal(string: taxString) ?? 0
        total = Decimal(string: totalString) ?? 0
        #if CUSTOMER
        restaurantName = json["restaurant_name"].string ?? ""
        #else
        customerName = json["customer_name"].string ?? ""
        table = String(describing: json["table"].int ?? 0)
        #endif
    }
}
