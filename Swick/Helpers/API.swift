//
//  API.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import Alamofire
import SwiftyJSON

struct API {
    
    // ##### SHARED API #####
    
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
    
    static func updateUserInfo(_ name: String, _ email: String, completion: @escaping (JSON) -> Void) {
        let path = "api/update_info/"
        let params = [
            "name": name,
            "email": email
        ]
        authRequest(path, method: .post, parameters: params, completion: completion)
    }
    
    // ##### CUSTOMER API #####
    #if CUSTOMER
    
    static func login(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/login/"
        authRequest(path, method: .post, completion: completion)
    }
    
    static func getRestaurants(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_restaurants/"
        request(path, completion: completion)
    }
    
    static func getRestaurant(_ restaurantId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_restaurant/\(restaurantId)/"
        request(path, completion: completion)
    }

    static func getCategories(_ restaurantId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_categories/\(restaurantId)"
        request(path, completion: completion)
    }

    static func getMeals(_ restaurantId: Int, _ categoryId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_meals/\(restaurantId)/\(categoryId)/"
        request(path, completion: completion)
    }

    static func getMeal(_ mealId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_meal/\(mealId)/"
        request(path, completion: completion)
    }

    static func getRequestOptions(_ restaurantId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_request_options/\(restaurantId)/"
        request(path, completion: completion)
    }

    static func makeRequest(_ requestOptionId: Int, table: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/make_request/"
        let params = [
            "request_option_id": requestOptionId,
            "table": table
        ]
        authRequest(path, method: .post, parameters: params, completion: completion)
    }

    static func placeOrder(_ restaurantId: Int, _ table: Int, _ cart: [CartItem], _ paymentMethodId: String, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/place_order/"

        // Build items array
        var itemsArray: [[String: Any]] = []
        for item in cart {
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
                "payment_method_id": paymentMethodId
            ]
            authRequest(path, method: .post, parameters: params, completion: completion)
        }
        catch {
            print(error)
        }
    }

    static func getOrders(completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_orders/"
        authRequest(path, completion: completion)
    }

    static func getOrderDetails(_ orderId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/customer/get_order_details/\(orderId)/"
        authRequest(path, completion: completion)
    }

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
        authRequest(path, method: .post, parameters: params, completion: completion)
    }

    static func retryPayment(_ paymentIntentId: String, completion: @escaping (JSON) -> Void){
        let path = "api/customer/retry_payment/"
        let params =
            ["payment_intent_id": paymentIntentId]
        authRequest(path, method: .post, parameters: params, completion: completion)
    }
    
    // ##### SERVER API #####
    #else
    
    static func login(completion: @escaping (JSON) -> Void) {
        let path = "api/server/login/"
        authRequest(path, method: .post, completion: completion)
    }
    
    static func getUserInfo(completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_info/"
        authRequest(path, completion: completion)
    }
    
    static func getOrders(completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_orders/"
        authRequest(path, completion: completion)
    }
    
    static func getOrder(_ orderId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_order/\(orderId)/"
        authRequest(path, completion: completion)
    }
    
    static func getOrderDetails(_ orderId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_order_details/\(orderId)/"
        authRequest(path, completion: completion)
    }
    
    static func getOrderItemsToCook(completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_order_items_to_cook/"
        authRequest(path, completion: completion)
    }
    
    // Items to send include order items and requests
    static func getItemsToSend(completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_items_to_send/"
        authRequest(path, completion: completion)
    }
    
    static func updateOrderItemStatus(_ orderItemId: Int, _ status: String, completion: @escaping (JSON) -> Void) {
        let path = "api/server/update_order_item_status/"
        let params: [String: Any] = [
            "order_item_id": orderItemId,
            "status": status,
        ]
        authRequest(path, method: .post, parameters: params, completion: completion)
    }
    
    static func deleteRequest(_ id: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/server/delete_request/"
        let params: [String: Any] = [
            "id": id
        ]
        authRequest(path, method: .post, parameters: params, completion: completion)
    }
    
    #endif
}
