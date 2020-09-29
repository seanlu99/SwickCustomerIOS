//
//  APIManager.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/12/20.
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
    
    // Create server account
    static func createAccount(completion: @escaping (JSON) -> Void) {
        let path = "api/server/create_account/"
        authRequest(path, method: .post, completion: completion)
    }
    
    // Get orders
    static func getOrders(_ status: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_orders/\(status)/"
        authRequest(path, completion: completion)
    }
    
    // Get order details
    static func getOrderDetails(_ orderId: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_order_details/\(orderId)/"
        authRequest(path, completion: completion)
    }
    
    // Update order status
    static func updateOrderStatus(_ orderId: Int, _ status: Int, completion: @escaping (JSON) -> Void) {
        let path = "api/server/update_order_status/"
        let params = [
            "order_id": orderId,
            "status": status,
        ]
        authRequest(path, method: .post, parameters: params, completion: completion)
    }
    
    // Get user info
    static func getUserInfo(completion: @escaping (JSON) -> Void) {
        let path = "api/server/get_info/"
        authRequest(path, completion: completion)
    }
    
    // Update user info
    static func updateUserInfo(_ name: String, _ email: String, completion: @escaping (JSON) -> Void) {
        let path = "api/update_info/"
        let params = [
            "name": name,
            "email": email
        ]
        authRequest(path, method: .post, parameters: params, completion: completion)
    }
}
