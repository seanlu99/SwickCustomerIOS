//
//  Meal.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import Foundation

struct Meal: Identifiable {
    var id: Int
    var name: String
    var description: String
    var price: Decimal
    var tax: Decimal
    var imageUrl: String
}
