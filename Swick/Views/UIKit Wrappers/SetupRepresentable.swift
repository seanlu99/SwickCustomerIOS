//
//  SetupRepresentable.swift
//  Swick
//
//  Taken from https://github.com/stripe/stripe-ios/issues/1204#issuecomment-686473756
//

import SwiftUI
import UIKit
import Stripe


class CardParamsWrapper : ObservableObject {
    var cardParams: STPPaymentMethodCardParams
    
    init(_ cardParams: STPPaymentMethodCardParams){
        self.cardParams = cardParams
    }
}

struct CardSetupCaller: UIViewControllerRepresentable {
    @Binding var attemptSetup: Bool
    @Binding var cardParamsWrapper: CardParamsWrapper?
    var onStripeResponse: (Bool, String) -> ()
    
    public typealias UIViewControllerType = SetupCallerViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CardSetupCaller>) -> SetupCallerViewController {
        let viewController = SetupCallerViewController(cardParamsWrapper)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: SetupCallerViewController, context _: UIViewControllerRepresentableContext<CardSetupCaller>) {
        uiViewController.cardParamsWrapper = cardParamsWrapper
        if attemptSetup {
            uiViewController.setup()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, StripeCallerDelegate {
        func didFinishStripeCall(_ successful: Bool, _ message: String) {
            parent.attemptSetup = false
            parent.onStripeResponse(successful, message)
        }
        
        var parent: CardSetupCaller

        init(_ parent: CardSetupCaller) {
            self.parent = parent
        }
    }
}

class SetupCallerViewController: UIViewController {
    var cardParamsWrapper: CardParamsWrapper?
    var delegate: StripeCallerDelegate?
    var blockSetup = false
   
    convenience init(_ cardParamsWrapper: CardParamsWrapper?) {
        self.init(cardParamsWrapper, false)
    }
    
    init(_ cardParamsWrapper: CardParamsWrapper?, _ blockSetup: Bool) {
        self.blockSetup = blockSetup
        self.cardParamsWrapper = cardParamsWrapper
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(){
        if blockSetup {
            return
        }
        blockSetup = true
        API.createSetupIntent{json in
            if (json["status"] == "success") {
                // Retrive client secret from response
                let setupIntentClientSecret = json["client_secret"].rawString() ?? ""
                // Can modify billingDetails parameters (ie: Address, email) if needed for future payments
                let billingDetails = STPPaymentMethodBillingDetails()
                // TODO: OPTIONAL UNWRAPPING
                let paymentMethodParams = STPPaymentMethodParams(card: self.cardParamsWrapper!.cardParams, billingDetails: billingDetails, metadata: nil)
                let setupIntentParams = STPSetupIntentConfirmParams(clientSecret: setupIntentClientSecret)
                setupIntentParams.paymentMethodParams = paymentMethodParams

                let paymentHandler = STPPaymentHandler.shared()
                
                // Stripe API call to attach payment
                paymentHandler.confirmSetupIntent(withParams: setupIntentParams, authenticationContext: self){status, setupIntent, error in
                    switch (status) {
                    case .failed:
                        self.blockSetup = false
                        self.delegate?.didFinishStripeCall(false, error?.localizedDescription ?? "")
                        break
                    case .succeeded:
                        self.blockSetup = false
                        self.delegate?.didFinishStripeCall(true, "")
                        break
                    case .canceled:
                        self.blockSetup = false
                        self.delegate?.didFinishStripeCall(false, "Cancled adding card")
                        break
                    @unknown default:
                        self.blockSetup = false
                        self.delegate?.didFinishStripeCall(false, "Please try again")
                    }
                }
            }
            else{
                self.blockSetup = false
                self.delegate?.didFinishStripeCall(false, "Please try again")
            }
        }
    }
}

extension SetupCallerViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        self
    }
}

protocol StripeCallerDelegate {
    func didFinishStripeCall(_ successful: Bool, _ message: String)
}
