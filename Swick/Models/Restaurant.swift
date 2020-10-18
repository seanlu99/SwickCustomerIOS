//
//  Restaurant.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import Foundation
import SwiftyJSON

struct Restaurant: Identifiable {
    var id: Int
    var name: String
    var address: String
    var imageUrl: String
    
    init() {
        id = 0
        name = ""
        address = ""
        imageUrl = ""
    }
    
    init(id: Int, name: String, address: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.address = address
        self.imageUrl = imageUrl
    }
    
    init(_ json: JSON) {
        id = json["id"].int ?? 0
        name = json["name"].string ?? ""
        address = json["address"].string ?? ""
        imageUrl = json["image"].string ?? ""
    }
}
