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
    let tokenDefaults = UserDefaults.standard
    
    // Generic call to server API
    func requestServer(_ path: String, _ method: Alamofire.HTTPMethod, _ params: [String: Any]?, _ encoding: ParameterEncoding, _ completionHandler: @escaping (JSON) -> Void) {
        let url = baseURL!.appendingPathComponent(path)
        AF.request(url!, method: method, parameters: params, encoding: encoding).responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
                break
                
            case .failure:
                break
            }
        }
    }
    
    // Call server API to get Django access token
    func getToken(completionHandler: @escaping () -> Void) {
        let path = "auth/convert-token/"
        let params: [String: String] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            // Facebook access token
            "token": AccessToken.current!.tokenString,
            "user_type": "customer"
        ]
        requestServer(path, .post, params, JSONEncoding.default) { json in
            let accessToken = json["access_token"].string!
            let refreshToken = json["refresh_token"].string!
            // expires_in is time till expiration
            // Convert expires_in to expiration date/time
            let expiration = Date().addingTimeInterval(TimeInterval(json["expires_in"].int!))
            self.tokenDefaults.set(accessToken, forKey: "accessToken")
            self.tokenDefaults.set(refreshToken, forKey: "refreshToken")
            self.tokenDefaults.set(expiration, forKey: "expiration")
            completionHandler()
        }
    }
    
    // Call server API to revoke Django access token
    func revokeToken(completionHandler: @escaping () -> Void) {
        let path = "auth/revoke-token/"
        let params: [String: String] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            // Django access token
            "token": tokenDefaults.object(forKey: "accessToken") as! String
        ]
        requestServer(path, .post, params, JSONEncoding.default) { _ in
            completionHandler()
        }
    }
    
    // Call server API to refresh token if it's expired
    func refreshToken(completionHandler: @escaping () -> Void) {
        // If access token is expired
        if (Date() > tokenDefaults.object(forKey: "expiration") as! Date) {
            let path = "auth/token/"
            let params: [String: String] = [
                "grant_type": "refresh_token",
                "client_id": CLIENT_ID,
                "client_secret": CLIENT_SECRET,
                "refresh_token": tokenDefaults.object(forKey: "refreshToken") as! String
            ]
            requestServer(path, .post, params, JSONEncoding.default) { json in
                let accessToken = json["access_token"].string!
                let refreshToken = json["refresh_token"].string!
                // expires_in is time till expiration
                // Convert expires_in to expiration date/time
                let expiration = Date().addingTimeInterval(TimeInterval(json["expires_in"].int!))
                self.tokenDefaults.set(accessToken, forKey: "accessToken")
                self.tokenDefaults.set(refreshToken, forKey: "refreshToken")
                self.tokenDefaults.set(expiration, forKey: "expiration")
                completionHandler()
            }
        }
        else {
            completionHandler()
        }
    }
    
    // API call to get restaurant list
    func getRestaurants(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/get_restaurants/"
        self.requestServer(path, .get, nil, URLEncoding.default, completionHandler)
    }
    
    // API call to get menu
    func getMenu(restaurantId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/get_menu/\(restaurantId)/"
        self.requestServer(path, .get, nil, URLEncoding.default, completionHandler)
    }
    
    // API call to get user info
    func getUserInfo(completionHandler: @escaping (JSON) -> Void) {
        refreshToken {
            let path = "api/get_user_info/"
            let params: [String: Any] = [
                "access_token": self.tokenDefaults.object(forKey: "accessToken") as! String
            ]
            self.requestServer(path, .get, params, URLEncoding.default, completionHandler)
        }
    }
}
