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

class API {
    
    // Generic HTTP request to backend API
    static func request(_ path: String,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        headers: HTTPHeaders? = nil,
                        completion: @escaping (JSON) -> Void) {
        let backendURL = NSURL(string: BACKEND_URL)
        guard let url = backendURL?.appendingPathComponent(path) else {
            print("Error: server URL not set\n")
            return
        }
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   headers: headers
                   )
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    completion(JSON(value))
                    break
                case .failure(let error):
                    print(error)
                    break
                }
        }
    }
    
    // Generic HTTP request to backend API with auth token
    static func authRequest(_ path: String,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        completion: @escaping (JSON) -> Void) {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let headers : HTTPHeaders = [
            "Authorization": "Token " + token
        ]
        request(path, method: method, parameters: parameters, headers: headers, completion: completion)
    }
    
    // Send email to get verification code
    static func getVerificationCode(_ email: String, completion: @escaping (JSON) -> Void) {
        let path = "auth/email/"
        let params = [
            "email": email
        ]
        request(path, method: .post, parameters: params, completion: completion)
    }
    
    // Send email and verification code to get auth token
    static func getToken(_ email: String, _ code: String, completion: @escaping (JSON) -> Void) {
        let path = "auth/token/"
        let params = [
            "email": email,
            "token": code
        ]
        request(path, method: .post, parameters: params, completion: completion)
    }
    
    // Create customer account
    static func createAccount(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/create_account/"
        authRequest(path, method: .post, completion: completion)
    }
    
    // Get restaurant list
    static func getRestaurants(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_restaurants/"
        request(path, completion: completion)
    }
    
    // Get restaurant
    static func getRestaurant(_ restaurantId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_restaurant/\(restaurantId)/"
        request(path, completion: completion)
    }
    
    // Get categories list
    static func getCategories(_ restaurantId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_categories/\(restaurantId)"
        request(path, completion: completion)
    }
    
    // Get menu
    static func getMenu(_ restaurantId: Int, _ category: String, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_menu/\(restaurantId)/\(category)/"
        request(path, completion: completion)
    }
    
    // Get meal
    static func getMeal(_ mealId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_meal/\(mealId)/"
        request(path, completion: completion)
    }
    
    // Place order
    static func placeOrder(_ restaurantId: Int, _ table: Int, _ methodId: String, completion: @escaping (JSON) -> Void) {
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
                "restaurant_id": restaurantId,
                "table": table,
                "order_items": itemsString ?? "",
                "payment_method_id": methodId
            ]
            authRequest(path, method: .post, parameters: params, completion: completion)
        }
        catch {
            print(error)
        }
    }
    
    // Get orders
    static func getOrders(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_orders/"
        authRequest(path, completion: completion)
    }
    
    // Get order details
    static func getOrderDetails(_ orderId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_order_details/\(orderId)/"
        authRequest(path, completion: completion)
    }
    
    // Get user info
    static func getUserInfo(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_info/"
        authRequest(path, completion: completion)
    }
    
    static func createSetupIntent(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/setup_card/"
        authRequest(path, completion: completion)
    }
    
    static func getUserCards(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_cards/"
        authRequest(path, completion: completion)
    }
    
    static func removeUserCard(_ methodId: String, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/remove_card/"
        let params =
            ["payment_method_id": methodId]
        authRequest(path, method: .post, parameters: params,completion: completion)
    }
}
