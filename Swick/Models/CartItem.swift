//
//  CartItem.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import Foundation

struct CartItem: Identifiable {
    var id: Int
    var meal: Meal
    var quantity: Int
    var total: Decimal
    var customizations = [Customization]()
}
