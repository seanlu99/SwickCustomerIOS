//
//  AddCardVC.swift
//  SwickCustomerIOS
//
//  Created by Andrew Jiang on 9/15/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit
import Stripe

class AddCardVC: UIViewController {
    let semaphore = DispatchSemaphore(value: 1)

    
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    
    lazy var setupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(setup), for: .touchUpInside)
        return button
    }()
    
    lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Enter your email"
        emailTextField.borderStyle = .roundedRect
        return emailTextField
    }()
    
    lazy var mandateLabel: UILabel = {
        let mandateLabel = UILabel()
        // Collect permission to reuse the customer's card:
        // In your app, add terms on how you plan to process payments and
        // reference the terms of the payment in the checkout flow
        // See https://stripe.com/docs/strong-customer-authentication/faqs#mandates
        mandateLabel.text = "I authorise Stripe Samples to send instructions to the financial institution that issued my card to take payments from my card account in accordance with the terms of my agreement with you."
        mandateLabel.numberOfLines = 0
        mandateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        mandateLabel.textColor = .systemGray
        return mandateLabel
    }()
    
    @objc
    func setup(){
        self.setupButton.isEnabled = false
        let cardParams = cardTextField.cardParams
        API.createSetupIntent{json in
            if (json["status"] == "success") {
                // Retrive client secret from response
                let setupIntentClientSecret = json["client_secret"].rawString() ?? ""
                // Can modify billingDetails parameters (ie: Address, email) if needed for future payments
                let billingDetails = STPPaymentMethodBillingDetails()
                
                let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: billingDetails, metadata: nil)
                let setupIntentParams = STPSetupIntentConfirmParams(clientSecret: setupIntentClientSecret)
                setupIntentParams.paymentMethodParams = paymentMethodParams
                
                let paymentHandler = STPPaymentHandler.shared()
                
                // Stripe API call to attach payment
                paymentHandler.confirmSetupIntent(withParams: setupIntentParams, authenticationContext: self){status, setupIntent, error in
                    switch (status) {
                    case .failed:
                        Helper.alert(self, title: "Failed to add card", message: error?.localizedDescription ?? "")
                        break
                    case .succeeded:
                        self.performSegue(withIdentifier: "unwindToPaymentMethods", sender: self)
                        break
                    case .canceled:
                        Helper.alert(self, title: "Cancled adding card", message: error?.localizedDescription ?? "")
                        break
                    @unknown default:
                        Helper.alert(self, title: "Stripe processing error", message: "Please try again.")
                    }
                    self.setupButton.isEnabled = true
                }
            }
            else{
                Helper.alert(self, message: "Unable to setup card. Please try again.")
                self.setupButton.isEnabled = true;
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [emailTextField, cardTextField, setupButton, mandateLabel])
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
            view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
        ])    }
}

extension AddCardVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
