//
//  RequestOption.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 10/2/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class RequestOption {
    var id: Int
    var name: String
    
    init(json: JSON) {
        self.id = json["id"].int ?? -1
        self.name = json["name"].string ?? ""
    }
}
