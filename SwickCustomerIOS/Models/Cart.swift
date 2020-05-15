//
//  Cart.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/15/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation

class Cart {
    static let shared = Cart()
    var items = [CartItem]()
//    var table: Int!
    
    func getTotal() -> String {
        var total: Double = 0
        for item in self.items {
            total = total + item.meal.price * Double(item.quantity)
        }
        return Helper.formatPrice(total)
    }
    
    // Reset cart
    func reset() {
        self.items = []
    }
}

class CartItem {
    var meal: Meal!
    var quantity: Int!
    
    init(_ meal: Meal, _ quantity: Int) {
        self.meal = meal
        self.quantity = quantity
    }
}
