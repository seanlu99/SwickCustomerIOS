//
//  CartVC.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit
import Stripe

class CartVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pricesView: UIStackView!
    
    @IBOutlet weak var subtotalPriceLabel: UILabel!
    @IBOutlet weak var taxPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var selectPaymentButton: UIButton!
    @IBOutlet weak var pricesViewHeightConstraint: NSLayoutConstraint!
    
    let requestAlert = UIAlertController(title: "Request", message: nil, preferredStyle: .alert)
    
    // Restaurant scanned in previous view
    var restaurant: Restaurant!
    // Table scanned in previous view
    var table: Int!
    // List of request options
    var requestOptions = [RequestOption]()
    // Selected payment method
    var card: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRequestAlert()
        toggleViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        formatPaymentButton()
        toggleViews()
    }
    
    func toggleViews() {
        tableView.reloadData()
        // If there are no meals in cart
        if Cart.shared.items.count == 0 {
            // set prices view height for empty cart label
            pricesViewHeightConstraint.constant = 60
            // hide views
            pricesView.isHidden = true
            placeOrderButton.isHidden = true
            selectPaymentButton.isHidden = true
            emptyLabel.isHidden = false
        }
        // If there are meals in cart
        else {
            // recalculate new cart totals
            Cart.shared.recalculateCart()
            totalPriceLabel.text = Helper.formatPrice(Cart.shared.total)
            subtotalPriceLabel.text = Helper.formatPrice(Cart.shared.subtotal)
            taxPriceLabel.text = Helper.formatPrice(Cart.shared.tax)
            // set prices view height for subviews
            pricesViewHeightConstraint.constant = 150
            // unhide views
            pricesView.isHidden = false
            placeOrderButton.isHidden = false
            selectPaymentButton.isHidden = false
            emptyLabel.isHidden = true 
        }
    }
    
    // Load request options and add actions to alert
    func createRequestAlert() {
        API.getRequestOptions(restaurant.id) { json in
            if (json["status"] == "success") {
                self.requestOptions = []
                // optionsList = array of JSON request options
                let optionsList = json["request_options"].array ?? []
                // option = a JSON request option
                for option in optionsList {
                    let r = RequestOption(json: option)
                    self.requestOptions.append(r)
                }
                
                // Add actions to request alert
                for r in self.requestOptions {
                    let newAction = UIAlertAction(title: r.name, style: .default) { _ in
                        API.makeRequest(r.id, table: self.table) { json in
                            if (json["status"] == "request_in_progress") {
                                Helper.alert(self, message: "Request already sent")
                            }
                            else if (json["status"] != "success") {
                                Helper.alert(self)
                            }
                        }
                    }
                    self.requestAlert.addAction(newAction)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                self.requestAlert.addAction(cancelAction)
            }
        }
    }
    
    // Format payment button to show either "select payment" or card
    func formatPaymentButton() {
        var brandImage: UIImage?
        var cardInfo: String?
         
        if let c = card {
            brandImage = STPImageLibrary.brandImage(for: STPCard.brand(from: c.brand))
            cardInfo = "  \(c.brand) \(c.last4)".capitalized
        }
        else {
            cardInfo = "Select payment"
        }
        selectPaymentButton.setTitle(cardInfo, for: .normal)
        selectPaymentButton.setImage(brandImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    @IBAction func leaveRestaurant(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Leaving restaurant", message: "Your cart will be lost", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default){_ in
            (self.tabBarController as? TabBarVC)?.scannedRestaurant = false
             self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func requestButtonClicked(_ sender: Any) {
        self.present(requestAlert, animated: true)
    }
    
    @IBAction func selectPayment(_ sender: Any) {
        performSegue(withIdentifier: "CartToPaymentMethods", sender: self)
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        if card == nil {
            Helper.alert(self, message: "Please choose a payment method")
        }
        else{
            placeOrderButton.isEnabled = false
            API.placeOrder(self.restaurant.id, self.table, self.card.methodId) { json in
                if json["status"] == "success" {
                    let intentStatus = json["intent_status"].string ?? ""
                    
                    if intentStatus == "card_error" || intentStatus == "requires_payment_method" {
                        let paymentError = json["error"].string ?? ""
                        Helper.alert(self, title: "Payment failed", message: paymentError)
                        self.placeOrderButton.isEnabled = true
                    }
                    else if intentStatus == "succeeded" {
                        Cart.shared.reset()
                        self.toggleViews()
                        
                        let alertView = UIAlertController(title: "Success",
                                                          message: "Your order has been placed.",
                                                          preferredStyle: .alert)
                        
                        let goToOrders = UIAlertAction(title: "Go to orders", style: .default){ _ in
                            self.performSegue(withIdentifier: "unwindFromCartToOrder", sender: self)
                        }
                        
                        alertView.addAction(goToOrders)
                        self.placeOrderButton.isEnabled = true
                        self.present(alertView, animated: true, completion: nil)
                    }
                    else if intentStatus == "requires_action" || intentStatus == "requires_source_action" {
                        let clientSecret = json["client_secret"].string ?? ""
                        let paymentHandler = STPPaymentHandler.shared()
                        paymentHandler.handleNextAction(forPayment: clientSecret, authenticationContext: self, returnURL: nil) { status, paymentIntent, handleActionError in
                            switch (status) {
                            case .failed:
                                Helper.alert(self, title: "Payment failed", message: handleActionError?.localizedDescription ?? "")
                                self.placeOrderButton.isEnabled = true
                                break
                            case .canceled:
                                Helper.alert(self, message: "Payment was canceled")
                                self.placeOrderButton.isEnabled = true
                                break
                            case .succeeded:
                                // requires reconfirmation with server
                                if let paymentIntent = paymentIntent, paymentIntent.status == STPPaymentIntentStatus.requiresConfirmation {
                                    API.retryPayment(paymentIntent.stripeId){ json in
                                        if json["status"] == "success" {
                                            let intentStatus = json["intent_status"].string ?? ""
                                            
                                            if intentStatus == "card_error" || intentStatus == "requires_payment_method" {
                                                let paymentError = json["error"].string ?? ""
                                                self.placeOrderButton.isEnabled = true
                                                Helper.alert(self, title: "Payment failed", message: paymentError)
                                            }
                                            else if intentStatus == "succeeded"{
                                                Cart.shared.reset()
                                                self.toggleViews()
                                                
                                                let alertView = UIAlertController(title: "Success",
                                                                                  message: "Your order has been placed.",
                                                                                  preferredStyle: .alert)
                                                
                                                let goToOrders = UIAlertAction(title: "Go to orders", style: .default){ _ in
                                                    self.performSegue(withIdentifier: "unwindFromCartToOrder", sender: self)
                                                }
                                                alertView.addAction(goToOrders)
                                                self.placeOrderButton.isEnabled = true
                                                self.present(alertView, animated: true, completion: nil)
                                            }
                                        }
                                        else {
                                            Helper.alert(self, message: "Failed to place order. Please try again.")
                                            self.placeOrderButton.isEnabled = true
                                        }
                                    }
                                }
                                else{
                                    Helper.alert(self, message: "Failed to place order. Please try again")
                                    self.placeOrderButton.isEnabled = true
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
                    Helper.alert(self, message: alertMessage)
                    self.placeOrderButton.isEnabled = true
                }
                else {
                    Helper.alert(self, message: "Failed to place order. Please try again.")
                    self.placeOrderButton.isEnabled = true
                }
            }
        }
        
    }
    
    @IBAction func unwindToCart( _ seg: UIStoryboardSegue) { }
    
    // Send restaurant object to categories VC and set cameFromCart flag
    // to true when "Add items to cart" button is clicked
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CartToCategory" {
            let categoryVC = segue.destination as! CategoryVC
            categoryVC.restaurant = restaurant
            categoryVC.cameFromCart = true
        }
        if segue.identifier == "CartToPaymentMethods" {
            let paymentMethodsVC = segue.destination as! PaymentMethodsVC
            paymentMethodsVC.previousView = "CartVC"
        }
    }
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.items.count
    }
    
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let cartItem = Cart.shared.items[indexPath.row]
        
        // Set labels
        cell.nameLabel.text = cartItem.meal.name
        cell.quantityLabel.text = String(cartItem.quantity)
        cell.totalLabel.text = Helper.formatPrice(cartItem.total)
        cell.customizationLabel.text = cartItem.getCustomizationString()
        
        return cell
    }
    
    // Delete cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Cart.shared.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Reload view
            viewDidAppear(true)
        }
    }
}

extension CartVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

