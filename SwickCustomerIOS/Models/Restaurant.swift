//
//  Restaurant.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/14/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class Restaurant {
    var id: Int!
    var name: String!
    var address: String!
    var image: String?
    
    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.address = json["address"].string
        self.image = json["image"].string
    }
}
