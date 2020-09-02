//
//  Helper.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 8/12/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import UIKit

// Helper methods
class Helper {
    
    // Show alert
    static func alert(_ title: String, _ message: String, _ view: UIViewController) {
        let alertView = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertView.addAction(okAction)
        view.present(alertView, animated: true, completion: nil)
    }
    
    // Format double as price
    static func formatPrice(_ price: Double) -> String {
        return String(format: "$%.2f", price)
    }
    
    // Convert hex integer to UIColor
    static func hexColor(_ hex: Int) -> UIColor {
        return UIColor(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
