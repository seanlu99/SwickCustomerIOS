//
//  FBManager.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class FBManager {
    
    // Use static so user can only create a single login manager
    static let shared = LoginManager()
    
    // Get name and email of user from Facebook
    public class func getFBUserData(completionHandler: @escaping () -> Void) {
        if (AccessToken.current != nil) {
            // After GraphRequest runs, store returned Json in User object
            GraphRequest(graphPath: "me", parameters: ["fields": "name, email"])
                .start { (connection, result, error) in
                    if (error == nil) {
                        let json = JSON(result!)
                        User.currentUser.setInfo(json: json)
                        completionHandler()
                    }
            }
        }
    }
}
