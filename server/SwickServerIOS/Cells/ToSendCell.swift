//
//  ToSendCell.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 9/30/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import UIKit

class ToSendCell: UITableViewCell {
    
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
