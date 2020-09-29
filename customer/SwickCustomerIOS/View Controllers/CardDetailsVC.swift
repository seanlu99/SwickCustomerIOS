//
//  CardDetailsVC.swift
//  SwickCustomerIOS
//
//  Created by Andrew Jiang on 9/16/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit
import Stripe.STPImageLibrary

class CardDetailsVC: UIViewController {
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var last4: UILabel!
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var deleteCardButton: UIButton!
    
    var card: Card!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brand.text = card.brand.capitalized
        last4.text = "****\(card.last4)"
        
        let expMonth_str = card.expMonth < 10 ? "0\(card.expMonth)" : "\(card.expMonth)"
        expDate.text = "\(expMonth_str)/\(card.expYear)"
        
        brandImage.image = STPImageLibrary.brandImage(for: STPCard.brand(from: card.brand))
    }
    
    @IBAction func deleteCard(_ sender: Any) {
        deleteCardButton.isEnabled = false;
        API.removeUserCard(card!.methodId){ json in
            if json["status"] == "success" {
                self.performSegue(withIdentifier: "unwindToPaymentMethods", sender: self)
            }
            else {
                Helper.alert(self, message: "Failed to delete card. Please try again.")
            }
            self.deleteCardButton.isEnabled = true
        }
    }
    
}
