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
    let serverURL = NSURL(string: SERVER_URL)
    let tokenDefaults = UserDefaults.standard
    
    // Generic call to server API
    func requestServer(_ path: String, _ method: Alamofire.HTTPMethod, _ params: [String: Any]?, _ encoding: ParameterEncoding, _ completionHandler: @escaping (JSON) -> Void) {
        guard let url = serverURL?.appendingPathComponent(path) else {
            print("Error: server URL not set\n")
            return
        }
        AF.request(url, method: method, parameters: params, encoding: encoding).responseJSON{ (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    // Call server API to get Django access token
    func getToken(completionHandler: @escaping () -> Void) {
        guard let fbToken = AccessToken.current?.tokenString else {
            print("Error: no Facebook access token\n")
            return
        }
        let path = "auth/convert-token/"
        let params: [String: String] = [
            "grant_type": "convert_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "backend": "facebook",
            "token": fbToken,
            "user_type": "customer"
        ]
        requestServer(path, .post, params, JSONEncoding.default) { json in
            let accessToken = json["access_token"].string
            let refreshToken = json["refresh_token"].string
            // expires_in is time till expiration
            // Convert expires_in to expiration date/time
            let expiresIn = json["expires_in"].int ?? 0
            let expiration = Date().addingTimeInterval(TimeInterval(expiresIn))
            self.tokenDefaults.set(accessToken, forKey: "accessToken")
            self.tokenDefaults.set(refreshToken, forKey: "refreshToken")
            self.tokenDefaults.set(expiration, forKey: "expiration")
            completionHandler()
        }
    }
    
    // Call server API to revoke Django access token
    func revokeToken(completionHandler: @escaping () -> Void) {
        guard let accessToken = tokenDefaults.object(forKey: "accessToken") as? String else {
            print("Error: no Django access token\n")
            return
        }
        let path = "auth/revoke-token/"
        let params: [String: String] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            // Django access token
            "token": accessToken
        ]
        requestServer(path, .post, params, JSONEncoding.default) { _ in
            completionHandler()
        }
    }
    
    // Call server API to refresh token if it's expired
    func refreshToken(completionHandler: @escaping () -> Void) {
        guard let refreshToken = self.tokenDefaults.object(forKey: "refreshToken") as? String else {
            print("Error: no Django access token\n")
            return
        }
        guard let expiration = tokenDefaults.object(forKey: "expiration") as? Date else {
            print("Error: no Django access token expiration date\n")
            return
        }
        // If access token is expired
        if (Date() > expiration) {
            let path = "auth/token/"
            let params: [String: String] = [
                "grant_type": "refresh_token",
                "client_id": CLIENT_ID,
                "client_secret": CLIENT_SECRET,
                "refresh_token": refreshToken
            ]
            requestServer(path, .post, params, JSONEncoding.default) { json in
                let accessToken = json["access_token"].string
                let refreshToken = json["refresh_token"].string
                // expires_in is time till expiration
                // Convert expires_in to expiration date/time
                let expiresIn = json["expires_in"].int ?? 0
                let expiration = Date().addingTimeInterval(TimeInterval(expiresIn))
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
    
    func getAccessToken() -> Any? {
        return tokenDefaults.object(forKey: "accessToken")
    }
    
    // API call to get restaurant list
    func getRestaurants(completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/get_restaurants/"
        self.requestServer(path, .get, nil, URLEncoding.default, completionHandler)
    }
    
    // API call to get categories list
    func getCategories(restaurantId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/get_categories/\(restaurantId)"
        self.requestServer(path, .get, nil, URLEncoding.default, completionHandler)
    }
    
    // API call to get menu
    func getMenu(restaurantId: Int, category: String, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/get_menu/\(restaurantId)/\(category)/"
        self.requestServer(path, .get, nil, URLEncoding.default, completionHandler)
    }
    
    // API call to get meal
    func getMeal(mealId: Int, completionHandler: @escaping (JSON) -> Void) {
        let path = "api/customer/get_meal/\(mealId)/"
        self.requestServer(path, .get, nil, URLEncoding.default, completionHandler)
    }
    
    // API to place order
    func placeOrder(completionHandler: @escaping (JSON) -> Void) {
        refreshToken {
            guard let accessToken = self.tokenDefaults.object(forKey: "accessToken") as? String else {
                print("Error: no Django access token\n")
                return
            }
            let path = "api/customer/place_order/"
            
            // Build items array
            var itemsArray: [[String: Any]] = []
            for item in Cart.shared.items {
                // Build customization array
                var custArray: [[String: Any]] = []
                for cust in item.customizations {
                    var options: [Int] = []
                    // Build options array
                    for (i, opt) in cust.options.enumerated() {
                        if opt.isChecked == true {
                            options.append(i)
                        }
                    }
                    // Only add customization if at least one option was checked
                    if options != [] {
                        custArray.append(
                            ["customization_id": cust.id,
                             "options": options
                            ]
                        )
                    }
                }
                // Add item to items array
                itemsArray.append(
                    ["meal_id": item.meal.id,
                     "quantity": item.quantity,
                     "customizations": custArray]
                )
            }

            do {
                // Convert items array into string format
                let itemsData = try JSONSerialization.data(withJSONObject: itemsArray, options: [])
                let itemsString = NSString(data: itemsData, encoding: String.Encoding.utf8.rawValue)
                let params: [String: Any] = [
                    "access_token": accessToken,
                    // HARDCODED FOR TESTING
                    "restaurant_id": "1",
                    "table": "5",
                    "order_items": itemsString ?? ""
                ]
                self.requestServer(path, .post, params, URLEncoding.default, completionHandler)
            }
            catch {
                print(error)
            }
        }
    }
    
    // API call to get order details
    func getOrders(completionHandler: @escaping (JSON) -> Void) {
        refreshToken {
            guard let accessToken = self.tokenDefaults.object(forKey: "accessToken") as? String else {
                print("Error: no Django access token\n")
                return
            }
            let path = "api/customer/get_orders/"
            let params: [String: Any] = [
                "access_token": accessToken
            ]
            self.requestServer(path, .get, params, URLEncoding.default, completionHandler)
        }
    }
    
    // API call to get order details
    func getOrderDetails(orderId: Int, completionHandler: @escaping (JSON) -> Void) {
        refreshToken {
            guard let accessToken = self.tokenDefaults.object(forKey: "accessToken") as? String else {
                print("Error: no Django access token\n")
                return
            }
            let path = "api/customer/get_order_details/\(orderId)/"
            let params: [String: Any] = [
                "access_token": accessToken
            ]
            self.requestServer(path, .get, params, URLEncoding.default, completionHandler)
        }
    }
    
    // API call to get user info
    func getUserInfo(completionHandler: @escaping (JSON) -> Void) {
        refreshToken {
            guard let accessToken = self.tokenDefaults.object(forKey: "accessToken") as? String else {
                print("Error: no Django access token\n")
                return
            }
            let path = "api/get_user_info/"
            let params: [String: Any] = [
                "access_token": accessToken
            ]
            self.requestServer(path, .get, params, URLEncoding.default, completionHandler)
        }
    }
}
