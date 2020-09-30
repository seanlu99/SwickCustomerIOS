//
//  ToCookCell.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 9/29/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class ToCookCell: UITableViewCell {

    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var customizationsLabel: UILabel!
    @IBOutlet weak var cookButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
