//
//  Meal.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import Foundation
import SwiftyJSON

struct Meal: Identifiable {
    var id: Int
    var name: String
    var description: String?
    var price: Decimal
    var tax: Decimal
    var imageUrl: String?
    
    init(
        id: Int,
        name: String,
        description: String,
        price: Decimal,
        tax: Decimal,
        imageUrl: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.tax = tax
        self.imageUrl = imageUrl
    }
    
    init(_ json: JSON) {
        let priceString = json["price"].string ?? ""
        let taxString = json["tax"].string ?? ""
        id = json["id"].int ?? 0
        name = json["name"].string ?? ""
        description = json["description"].string
        price = Decimal(string: priceString) ?? 0
        tax = Decimal(string: taxString) ?? 0
        imageUrl = json["image"].string
    }
}
