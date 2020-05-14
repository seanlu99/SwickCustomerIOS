//
//  User.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import SwiftyJSON

// User object
class User {
    static let currentUser = User()
    
    var name: String?
    var email: String?
    
    // Constructor with json
    func setInfo(json: JSON) {
        self.name = json["name"].string
        self.email = json["email"].string
    }
    
    // Reset properties
    func resetInfo() {
        self.name = nil
        self.email = nil
    }
}
