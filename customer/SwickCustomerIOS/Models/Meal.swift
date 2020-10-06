//
//  Meal.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/14/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class Meal {
    var id: Int
    var name: String
    var description: String
    var price: Decimal
    var tax: Decimal
    var image: String
    
    init(json: JSON) {
        let price_str = json["price"].string ?? ""
        let tax_str = json["tax"].string ?? ""
        
        self.id = json["id"].int ?? -1
        self.name = json["name"].string ?? ""
        self.description = json["description"].string ?? ""
        self.price = Decimal(string: price_str) ?? 0
        self.tax = Decimal(string: tax_str) ?? 0
        self.image = json["image"].string ?? ""
    }
}
