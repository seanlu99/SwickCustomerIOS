//
//  CartCell.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/15/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
