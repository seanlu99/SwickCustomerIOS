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
    var id: Int
    var name: String
    var min: Int
    var max: Int
    var options = [Option]()
    var numChecked = 0
    
    init(json: JSON) {
        self.id = json["id"].int ?? -1
        self.name = json["name"].string ?? ""
        let optionsList = json["options"].array ?? []
        let additionsList = json["price_additions"].array ?? []
        for (opt, addition) in zip(optionsList, additionsList) {
            let o = opt.string ?? ""
            let add = addition.string ?? ""
            let a = Decimal(string: add) ?? 0
            options.append(Option(o, a))
        }
        self.min = json["min"].int ?? 0
        self.max = json["max"].int ?? 0
    }
}

class Option {
    var name: String
    var priceAddition: Decimal
    var isChecked: Bool
    
    init(_ name: String, _ addition: Decimal) {
        self.name = name
        self.priceAddition = addition
        self.isChecked = false
    }
}
