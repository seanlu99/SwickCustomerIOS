//
//  Category.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import Foundation
import SwiftyJSON

struct Category: Identifiable {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init(_ json: JSON) {
        id = json["id"].int ?? 0
        name = json["name"].string ?? ""
    }
}
