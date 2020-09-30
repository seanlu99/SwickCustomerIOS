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
    
    // Get total of cart
    func getTotal() -> String {
        var total: Double = 0
        for item in items {
            total += item.total
        }
        return Helper.formatPrice(total)
    }
    
    // Reset cart
    func reset() {
        self.items = []
    }
}

class CartItem {
    var meal: Meal
    var quantity: Int
    var total: Double
    var customizations: [Customization]
    
    init(_ meal: Meal, _ quantity: Int, _ total: Double, _ customizations: [Customization]) {
        self.meal = meal
        self.quantity = quantity
        self.total = total
        self.customizations = customizations
    }
    
    // Return customizations as a formatted string
    func getCustomizationString() -> String {
        var str = ""
        for cust in customizations {
            var optionsStr = ""
            for opt in cust.options {
                if opt.isChecked == true {
                    optionsStr += "- " + opt.name + "\n"
                }
            }
            // Only add customization name if at least one option was checked
            if optionsStr != "" {
                str += cust.name + "\n" + optionsStr
            }
        }
        // Remove last new line
        if str != "" {
            str.remove(at: str.index(before: str.endIndex))
        }
        return str
    }
}
