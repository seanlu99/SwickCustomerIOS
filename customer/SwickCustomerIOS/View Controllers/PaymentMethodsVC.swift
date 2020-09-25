//
//  PaymentMethodsVC.swift
//  SwickCustomerIOS
//
//  Created by Andrew Jiang on 9/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit
import Stripe.STPImageLibrary

class PaymentMethodsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var cards = [Card]()
    var clientSecret: String?
    var previousView: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCards()
    }
    
    // Get the current user's saved cards
    func getCards(){
        API.getUserCards(){ json in
            if json["status"] == "success" {
                self.cards.removeAll()
                for (_, cardJson) in json["cards"] {
                    self.cards.append(Card(json: cardJson))
                }
                self.tableView.reloadData()
            }
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCart" {
            let cartVC = segue.destination as! CartVC
            cartVC.card = cards[(tableView.indexPathForSelectedRow?.row) ?? 0]
        }
        if segue.identifier == "PaymentMethodsToCardDetails" {
            let cardDetailsVC = segue.destination as! CardDetailsVC
            cardDetailsVC.card = cards[(tableView.indexPathForSelectedRow?.row) ?? 0]
        }
    }
 
    // Button to add a new card to the account
    @IBAction func addCard(_ sender: UIButton) {
        performSegue(withIdentifier: "PaymentMethodsToAddCard", sender: self)
    }
    
    @IBAction func unwindToPaymentMethods( _ seg: UIStoryboardSegue) {
        getCards()
    }
}

extension PaymentMethodsVC: UITableViewDelegate, UITableViewDataSource {
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Set number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    // Properties for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let card = cards[indexPath.row]
        let cardImage = STPImageLibrary.brandImage(for: STPCard.brand(from: card.brand))
        cell.imageView?.image = cardImage
        cell.brandLastFour.text = "\(card.brand.capitalized) \(card.last4)"
        
        return cell
    }
    
    // On cell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if previousView == "CartVC" {
            self.performSegue(withIdentifier: "unwindToCart", sender: self)
        }
        if previousView == "AccountVC" {
            self.performSegue(withIdentifier: "PaymentMethodsToCardDetails", sender: self)
        }
    }
}

