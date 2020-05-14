//
//  APIManager.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class APIManager {
    static let shared = APIManager()
    let baseURL = NSURL(string: BASE_URL)
    // Django access token
    var accessToken = ""
    // Django refresh token
    var refreshToken = ""
    // Django access token expiration time
    var expired = Date()
    
    // Call server API to get Django access token
    func login(completionHandler: @escaping (NSError?) -> Void) {
        let path = "auth/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: String] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            // Facebook access token
            "token": AccessToken.current!.tokenString,
            "user_type": "customer"
        ]
        // Send HTTP request
        AF.request(url!, method: .post, parameters: params, encoder: JSONParameterEncoder.default).responseJSON { (response) in
            switch response.result {
                
            // If successful, set access token, refresh token, and expiration date
            case .success(let value):
                let jsonData = JSON(value)
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                // expires_in is time till expiration
                // Convert expires_in to expiration date/time
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
    }
    
    // Call server API to revoke Django access token
    func logout(completionHandler: @escaping (NSError?) -> Void) {
        let path = "auth/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: String] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            // Django access token
            "token": self.accessToken
        ]
        AF.request(url!, method: .post, parameters: params, encoder: JSONParameterEncoder.default).responseString { (response) in
            switch response.result {
                
            case .success:
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
    }
}
