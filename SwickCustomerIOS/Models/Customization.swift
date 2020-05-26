//
//  Customization.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/24/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class Customization {
    var id: Int!
    var name: String!
    var min: Int!
    var max: Int!
    var options: [Option] = []
    var numChecked = 0
    
    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        let optionsList = json["options"].array!
        let additionsList = json["price_additions"].array!
        for (opt, addition) in zip(optionsList, additionsList) {
            let o = opt.string!
            let a = Double(addition.string!)
            options.append(Option(o, a!))
        }
        self.min = json["min"].int
        self.max = json["max"].int
    }
}

class Option {
    var name: String!
    var priceAddition: Double!
    var isChecked: Bool!
    
    init(_ name: String, _ addition: Double) {
        self.name = name
        self.priceAddition = addition
        self.isChecked = false
    }
}
