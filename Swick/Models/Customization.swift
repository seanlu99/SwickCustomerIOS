//
//  Customization.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import Foundation

struct Customization: Identifiable {
    var id: Int
    var name: String
    // isCheckable extra fields
    var isCheckable = false
    var min: Int?
    var max: Int?
    var numChecked = 0
    var options = [Option]()
}

struct Option: Identifiable {
    var id: Int
    var name: String
    // isCheckable extra fields
    var priceAddition: Decimal?
    var isChecked: Bool = false
}
