//
//  Card.swift
//  SwickCustomerIOS
//
//  Created by Andrew Jiang on 9/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class Card {
    // stripe payment_method_id

    var methodId: String
    var brand: String
    var expMonth: Int
    var expYear: Int
    var last4: String
    
    init(json: JSON) {
        self.methodId = json["payment_method_id"].string ?? ""
        self.brand = json["brand"].string ?? ""
        self.expMonth = json["exp_month"].int ?? -1
        self.expYear = json["exp_year"].int ?? -1
        self.last4 = json["last4"].string ?? ""
    }
}
