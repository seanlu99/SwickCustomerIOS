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
    var id: Int!
    var name: String!
    var description: String!
    var price: Double!
    var image: String?
    
    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.description = json["description"].string
        let p = json["price"].string!
        self.price = Double(p)
        self.image = json["image"].string
    }
}
