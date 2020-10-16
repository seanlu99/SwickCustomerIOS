//
//  PaymentRepresentable.swift
//  Swick
//
//  Taken from https://github.com/stripe/stripe-ios/issues/1204#issuecomment-686473756
//

import SwiftUI
import UIKit
import Stripe

class PlaceOrderParamsWrapper : ObservableObject {
    var restaurantId: Int
    var table: Int
    var cart: [CartItem]
    var cardMethodId: String
    
    init(_ restaurantId: Int, _ table: Int,  _ cart: [CartItem], _ cardMethodId: String){
        self.restaurantId = restaurantId
        self.table = table
        self.cart = cart
        self.cardMethodId = cardMethodId
    }
}

struct PaymentCaller: UIViewControllerRepresentable {
    @Binding var attemptOrder: Bool
    @Binding var params: PlaceOrderParamsWrapper?
    var onStripeResponse: (Bool, String) -> ()
    
    public typealias UIViewControllerType = PaymentCallerViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PaymentCaller>) -> PaymentCallerViewController {
        // TODO: Refactopr view input for StripeRepresentable
        let viewController = PaymentCallerViewController(params)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: PaymentCallerViewController, context _: UIViewControllerRepresentableContext<PaymentCaller>) {
        uiViewController.params = params
        if attemptOrder {
            uiViewController.placeOrder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PaymentCallerDelegate {
        func didFinishStripeCall(_ successful: Bool, _ message: String) {
            parent.attemptOrder = false
            parent.onStripeResponse(successful, message)
        }
        
        var parent: PaymentCaller

        init(_ parent: PaymentCaller) {
            self.parent = parent
        }
    }
}

class PaymentCallerViewController: UIViewController {
    var params: PlaceOrderParamsWrapper?
    var delegate: PaymentCallerDelegate?
    var blockPayment = false
    
    init(_ params: PlaceOrderParamsWrapper?){
        self.params = params
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func placeOrder(){
        if blockPayment {
            return
        }
        blockPayment = true
        API.placeOrder(self.params!.restaurantId, self.params!.table, self.params!.cart, self.params!.cardMethodId) { [self] json in
            if json["status"] == "success" {
                let intentStatus = json["intent_status"].string ?? ""
                
                if intentStatus == "card_error" || intentStatus == "requires_payment_method" {
                    let paymentError = json["error"].string ?? ""
                    blockPayment = false
                    self.delegate?.didFinishStripeCall(false, paymentError)
                }
                else if intentStatus == "succeeded" {
                    blockPayment = false
                    self.delegate?.didFinishStripeCall(true, "Your order has been placed.")
                }
                else if intentStatus == "requires_action" || intentStatus == "requires_source_action" {
                    let clientSecret = json["client_secret"].string ?? ""
                    let paymentHandler = STPPaymentHandler.shared()
                    
                    paymentHandler.handleNextAction(forPayment: clientSecret, authenticationContext: self, returnURL: nil) { status, paymentIntent, handleActionError in
                        switch (status) {
                        case .failed:
                            blockPayment = false
                            delegate?.didFinishStripeCall(false , handleActionError?.localizedDescription ?? "")
                            break
                        case .canceled:
                            blockPayment = false
                            delegate?.didFinishStripeCall(false , handleActionError?.localizedDescription ?? "")
                            break
                        case .succeeded:
                            if let paymentIntent = paymentIntent, paymentIntent.status == STPPaymentIntentStatus.requiresConfirmation {
                                retryOrder(paymentIntent)
                            }
                            break
                        @unknown default:
                            fatalError()
                            break
                        }
                    }
                }
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
    
    
    func retryOrder(_ paymentIntent: STPPaymentIntent){
        API.retryPayment(paymentIntent.stripeId){ json in
            if json["status"] == "success" {
                let intentStatus = json["intent_status"].string ?? ""
                
                if intentStatus == "card_error" || intentStatus == "requires_payment_method" {
                    let paymentError = json["error"].string ?? ""
                    self.blockPayment = false
                    self.delegate?.didFinishStripeCall(false, paymentError)
                }
                else if intentStatus == "succeeded"{
                    self.blockPayment = false
                    self.delegate?.didFinishStripeCall(true, "Your order has been placed.")
                }
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
