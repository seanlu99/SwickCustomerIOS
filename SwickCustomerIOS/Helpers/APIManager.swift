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
    
    // Call server API to get Django access token
    func getToken(completionHandler: @escaping (NSError?) -> Void) {
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
                
            // If successful, set access token, refresh token and expiration date
            case .success(let value):
                let jsonData = JSON(value)
                let accessToken = jsonData["access_token"].string!
                let refreshToken = jsonData["refresh_token"].string!
                // expires_in is time till expiration
                // Convert expires_in to expiration date/time
                let expiration = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                self.tokenDefaults.set(accessToken, forKey: "accessToken")
                self.tokenDefaults.set(refreshToken, forKey: "refreshToken")
                self.tokenDefaults.set(expiration, forKey: "expiration")
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
    }
    
    // Call server API to revoke Django access token
    func revokeToken(completionHandler: @escaping (NSError?) -> Void) {
        let path = "auth/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: String] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            // Django access token
            "token": tokenDefaults.object(forKey: "accessToken") as! String
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
    
    // Call server API to refresh token if it's expired
    func refreshToken(completionHandler: @escaping () -> Void) {
        // If access token is expired
        if (Date() > tokenDefaults.object(forKey: "expiration") as! Date) {
            let path = "auth/token/"
            let url = baseURL?.appendingPathComponent(path)
            let params: [String: String] = [
                "grant_type": "refresh_token",
                "client_id": CLIENT_ID,
                "client_secret": CLIENT_SECRET,
                "refresh_token": tokenDefaults.object(forKey: "refreshToken") as! String
            ]
            AF.request(url!, method: .post, parameters: params, encoder: JSONParameterEncoder.default).responseJSON{ (response) in
                switch response.result {
                    
                // If successful, set access token, refresh token and expiration date
                case .success(let value):
                    let jsonData = JSON(value)
                    let accessToken = jsonData["access_token"].string!
                    let refreshToken = jsonData["refresh_token"].string!
                    // expires_in is time till expiration
                    // Convert expires_in to expiration date/time
                    let expiration = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                    self.tokenDefaults.set(accessToken, forKey: "accessToken")
                    self.tokenDefaults.set(refreshToken, forKey: "refreshToken")
                    self.tokenDefaults.set(expiration, forKey: "expiration")
                    completionHandler()
                    break
                    
                case .failure:
                    break
                }
            }
        }
        else {
            completionHandler()
        }
    }
    
    // Generic call to server API
    func requestServer(_ path: String,_ method: Alamofire.HTTPMethod,_ params: [String: String]?,_ completionHandler: @escaping (JSON) -> Void) {
        let url = baseURL?.appendingPathComponent(path)
        refreshToken {
            AF.request(url!, method: method, parameters: params, encoder: JSONParameterEncoder.default).responseJSON{ (response) in
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(nil!)
                    break
                }
            }
        }
    }
    
    // API call to get restaurant list
    func getRestaurants(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/get_restaurants/"
        requestServer(path, .get, nil, completionHandler)
    }
    
    // API call to get menu
    func getMenu(restaurantId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/get_menu/\(restaurantId)/"
        requestServer(path, .get, nil, completionHandler)
    }
}
