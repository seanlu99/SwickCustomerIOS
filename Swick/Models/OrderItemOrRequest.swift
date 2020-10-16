//
//  Request.swift
//  Server
//
//  Created by Sean Lu on 10/15/20.
//

import Foundation

struct OrderItemOrRequest: Identifiable {
    // O<order_id> for order
    // R<request_id> for request
    var id: String
    var table: String
    var name: String
    var customerName: String
    // Only for order items
    var orderId: Int?
}
