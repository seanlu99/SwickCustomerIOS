//
//  Customization.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import Foundation
import SwiftyJSON

struct Customization: Identifiable {
    var id: Int
    var name: String
    var options = [Option]()
    // isCheckable extra fields
    var min: Int
    var max: Int
    var isCheckable: Bool
    var numChecked = 0
    
    init(
        id: Int,
        name: String,
        options: [Option],
        min: Int = 0,
        max: Int = 0,
        isCheckable: Bool = false
    ) {
        self.id = id
        self.name = name
        self.min = min
        self.max = max
        self.options = options
        self.isCheckable = isCheckable
    }
    
    init(_ json: JSON, isCheckable: Bool = false) {
        id = json["id"].int ?? 0
        let optionJsonList = json["options"].array ?? []
        if isCheckable {
            name = json["name"].string ?? ""
            let additionJsonList = json["price_additions"].array ?? []
            for (i, optionJson) in optionJsonList.enumerated() {
                let option = optionJson.string ?? ""
                let additionString = additionJsonList[i].string ?? ""
                let addition = Decimal(string: additionString) ?? 0
                options.append(
                    Option(
                        id: i,
                        name: option,
                        priceAddition: addition
                    )
                )
            }
        }
        else {
            name = json["customization_name"].string ?? ""
            for (i, optionJson) in optionJsonList.enumerated() {
                let option = optionJson.string ?? ""
                options.append(
                    Option(
                        id: i,
                        name: option
                    )
                )
            }
        }
        min = json["min"].int ?? 0
        max = json["max"].int ?? 0
        self.isCheckable = isCheckable
    }
}

struct Option: Identifiable {
    var id: Int
    var name: String
    // isCheckable extra fields
    var isChecked: Bool = false
    var priceAddition: Decimal = 0
}
