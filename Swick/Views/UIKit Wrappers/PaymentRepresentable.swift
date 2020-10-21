//
//  PaymentRepresentable.swift
//  Swick
//
//  Taken from https://github.com/stripe/stripe-ios/issues/1204#issuecomment-686473756
//

import SwiftUI
import UIKit
import Stripe
import SwiftyJSON

protocol PaymentParams {
    var cardMethodId: String { get set}
}

enum PaymentType { case order, tip}

struct PlaceOrderParams : PaymentParams{
    var restaurantId: Int
    var table: Int
    var cart: [CartItem]
    var tip: Decimal?
    var cardMethodId: String
    
    init(_ restaurantId: Int, _ table: Int,  _ cart: [CartItem],_ tip: Decimal?, _ cardMethodId: String) {
        self.restaurantId = restaurantId
        self.table = table
        self.cart = cart
        self.tip = tip
        self.cardMethodId = cardMethodId
    }
}

struct AddTipParams : PaymentParams{
    var orderId: Int
    var tip: Decimal
    var cardMethodId: String

    init(_ orderId: Int, _ tip: Decimal, _ cardMethodId: String? = nil) {
        self.orderId = orderId
        self.tip = tip
        self.cardMethodId = cardMethodId ?? ""
    }
}

class PaymentParamsWrapper : ObservableObject {
    var params: PaymentParams
    
    init(_ params: PaymentParams){
        self.params = params
    }
}

struct PaymentCaller: UIViewControllerRepresentable {
    @Binding var attempt: Bool
    @Binding var paramsWrapper: PaymentParamsWrapper?
    
    var onStripeResponse: (Bool, String) -> ()
    
    public typealias UIViewControllerType = PaymentCallerViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PaymentCaller>) -> PaymentCallerViewController {
        let viewController = PaymentCallerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: PaymentCallerViewController, context _: UIViewControllerRepresentableContext<PaymentCaller>) {
        if attempt {
            if let placeOrderParams = paramsWrapper?.params as? PlaceOrderParams {
                uiViewController.placeOrder(placeOrderParams)
            }
            if let addTipParams = paramsWrapper?.params as? AddTipParams {
                uiViewController.addTip(addTipParams)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PaymentCallerDelegate {
        func didFinishStripeCall(_ successful: Bool, _ message: String) {
            parent.attempt = false
            parent.onStripeResponse(successful, message)
        }
        
        var parent: PaymentCaller

        init(_ parent: PaymentCaller) {
            self.parent = parent
        }
    }
}

class PaymentCallerViewController: UIViewController {
    var delegate: PaymentCallerDelegate?
    var blockPayment = false
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func placeOrder(_ params: PlaceOrderParams){
        if blockPayment {
            return
        }
        blockPayment = true
        API.placeOrder(params.restaurantId, params.table, params.cart, params.tip, params.cardMethodId) { [self] json in
            if json["status"] == "success" {
                handleResponse(json, clientSuccessMessage: "Your order has been placed.", .order)
            }
            // Check if any of selected meals have been disabled
            else if (json["status"] == "meal_disabled") {
                let disabled_meal = json["meal_name"].string ?? ""
                let alertMessage = disabled_meal + " has been disabled by the restaurant. Please remove it from your cart and try again."
                blockPayment = false
                self.delegate?.didFinishStripeCall(false, alertMessage)
            }
            else {
                blockPayment = false
                self.delegate?.didFinishStripeCall(false, "Failed to place order. Please try again")
            }
        }
    }
    
    func addTip(_ params : AddTipParams) {
        if blockPayment {
            return
        }
        blockPayment = true
        API.addTip(params.orderId, tip: params.tip) { json in
            if json["status"] == "success" {
                self.handleResponse(json, clientSuccessMessage: "You tip has been sent.", .tip)
            }
        }
    }

    func handleResponse (_ json: JSON, clientSuccessMessage: String,_ type: PaymentType) {
        let intentStatus = json["intent_status"].string ?? ""
        
        if intentStatus == "card_error" || intentStatus == "requires_payment_method" {
            let paymentError = json["error"].string ?? ""
            blockPayment = false
            self.delegate?.didFinishStripeCall(false, paymentError)
        }
        else if intentStatus == "succeeded" {
            blockPayment = false
            self.delegate?.didFinishStripeCall(true, clientSuccessMessage)
        }
        else if intentStatus == "requires_action" || intentStatus == "requires_source_action" {
            let clientSecret = json["client_secret"].string ?? ""
            let paymentHandler = STPPaymentHandler.shared()
            
            paymentHandler.handleNextAction(forPayment: clientSecret, authenticationContext: self, returnURL: nil) { status, paymentIntent, handleActionError in
                switch (status) {
                case .failed:
                    self.blockPayment = false
                    self.delegate?.didFinishStripeCall(false , handleActionError?.localizedDescription ?? "")
                    break
                case .canceled:
                    self.blockPayment = false
                    self.delegate?.didFinishStripeCall(false , handleActionError?.localizedDescription ?? "")
                    break
                case .succeeded:
                    if let paymentIntent = paymentIntent, paymentIntent.status == STPPaymentIntentStatus.requiresConfirmation {
                        
                        self.retryPayment(paymentIntent, clientSuccessMessage: clientSuccessMessage, type)
                    }
                    break
                @unknown default:
                    fatalError()
                    break
                }
            }
        }
    }
    

    func retryPayment(_ paymentIntent: STPPaymentIntent, clientSuccessMessage: String,_ type: PaymentType) {
        if type == .order {
            API.retryOrder(paymentIntent.stripeId){ json in
                self.handleRetryResponse(json, clientSuccessMessage)
            }
        }
        else if type == .tip {
            API.retryTip(paymentIntent.stripeId){ json in
                self.handleRetryResponse(json, clientSuccessMessage)
            }
        }
    }
    func handleRetryResponse(_ json: JSON,_ clientSuccessMessage: String) {
        if json["status"] == "success" {
            let intentStatus = json["intent_status"].string ?? ""
            
            if intentStatus == "card_error" || intentStatus == "requires_payment_method" {
                let paymentError = json["error"].string ?? ""
                self.blockPayment = false
                self.delegate?.didFinishStripeCall(false, paymentError)
            }
            else if intentStatus == "succeeded"{
                self.blockPayment = false
                self.delegate?.didFinishStripeCall(true, clientSuccessMessage)
            }
        }
    }
}

extension PaymentCallerViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        self
    }
}

protocol PaymentCallerDelegate {
    func didFinishStripeCall(_ successful: Bool, _ message: String)
}
