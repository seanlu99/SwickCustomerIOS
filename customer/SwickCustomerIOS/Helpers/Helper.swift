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
    
    // Test if email is valid
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // Show error alert
    static func alertError(_ view: UIViewController,
                           _ message: String = "Bad request. Please try again.") {
        let alertView = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertView.addAction(okAction)
        view.present(alertView, animated: true, completion: nil)
    }
    
    // Switch root view
    static func switchRootView(_ identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: identifier)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarVC
    }
}
