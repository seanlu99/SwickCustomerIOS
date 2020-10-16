//
//  Order.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import Foundation

struct Order: Identifiable {
    var id: Int
    var time: Date
    var status: String?
    var subtotal: Decimal?
    var tax: Decimal?
    var total: Decimal?
    #if CUSTOMER
    var restaurantName: String
    #else
    var customerName: String
    var table: String?
    #endif
}
