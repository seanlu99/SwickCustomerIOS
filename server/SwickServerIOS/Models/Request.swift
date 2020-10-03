//
//  Request.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 10/2/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

class Request {
    var id: Int
    var requestName: String
    var table: String
    var customer: String
    
    init(json: JSON) {
        self.id = json["id"].int ?? -1
        self.requestName = json["request_name"].string ?? ""
        self.table = String(describing: json["table"].int ?? 0)
        self.customer = json["customer"].string ?? ""
    }
}
