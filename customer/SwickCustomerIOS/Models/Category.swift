//
//  Category.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 10/4/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    var id: Int
    var name: String
    
    init(json: JSON) {
        self.id = json["id"].int ?? 0
        self.name = json["name"].string ?? ""
    }
    
    init(_ id: Int, _ name: String) {
        self.id = id
        self.name = name
    }
}
