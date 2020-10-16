//
//  OrderItem.swift
//  Swick
//
//  Created by Sean Lu on 10/9/20.
//

import Foundation

struct OrderItem: Identifiable {
    var id: Int
    var mealName: String
    var quantity: Int?
    var total: Decimal?
    var status: String?
    var customizations: [Customization] = []
    #if SERVER
    // Order fields for to cook and to send
    var orderId: Int?
    var customerName: String?
    var table: String?
    #endif
}
