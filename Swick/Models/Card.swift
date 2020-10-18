//
//  Card.swift
//  Swick
//
//  Created by Andrew Jiang on 10/9/20.
//

import Foundation
import SwiftyJSON

struct Card: Identifiable{
    var id: String
    var brand: String
    var expMonth: Int
    var expYear: Int
    var last4: String
    
    init(
        id: String,
        brand: String,
        expMonth: Int,
        expYear: Int,
        last4: String
    ) {
        self.id = id
        self.brand = brand
        self.expMonth = expMonth
        self.expYear = expYear
        self.last4 = last4
    }
    
    init(_ json: JSON) {
        id = json["payment_method_id"].string ?? ""
        brand = json["brand"].string ?? ""
        expMonth = json["exp_month"].int ?? 0
        expYear = json["exp_year"].int ?? 0
        last4 = json["last4"].string ?? ""
    }
}
