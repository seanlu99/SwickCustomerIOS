//
//  RestaurantCell.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/14/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
