//
//  CustomizationCell.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/24/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class CustomizationCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var additionLabel: UILabel!
    @IBOutlet weak var checkbox: Checkbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
