//
//  Helper.swift
//  SwickCustomerIOS
//
//  Created by Sean Lu on 5/13/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import UIKit

// Helper methods
class Helper {
    
    // Load imageString image into imageView
    static func loadImage(_ imageView: UIImageView,_ imageString: String) {
        guard let imageUrl = URL(string: imageString) else {
            print("Error: invalid image URL\n")
            return
        }
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async(execute: {
                imageView.image = UIImage(data: data)
            })
        }.resume()
    }
    
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
    
    // Convert string to date
    static func convertStringToDate(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        return formatter.date(from: str) ?? Date()
    }
    
    // Convert date to string
    static func convertDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy h:mma"
        return formatter.string(from: date)
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
