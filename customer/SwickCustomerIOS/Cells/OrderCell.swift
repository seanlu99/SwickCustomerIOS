//
//  OrderCell.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/15/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
