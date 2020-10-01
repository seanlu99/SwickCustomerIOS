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
    
    // Show alert
    static func alert(_ view: UIViewController,
                        title: String = "Error",
                        message: String = "Bad request. Please try again.") {
        let alertView = UIAlertController(
            title: title,
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
    
    // Build no restaurant label and add to given view
    static func addNoRestaurantLabel(_ view: UIView, _ label: UILabel) {
        label.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
        label.center = view.center
        label.textAlignment = NSTextAlignment.center
        label.text = "Your restaurant must add you as a server"
        label.isHidden = true
        view.addSubview(label)
    }
    
    // Return customizations as a formatted string
    static func buildCustomizationsString(_ customizations: [OrderItemCustomization]) -> String {
        var str = ""
        for cust in customizations {
            str += cust.name + "\n"
            for opt in cust.options {
                str += "- " + opt + "\n"
            }
        }
        // Remove last new line
        if str != "" {
            str.remove(at: str.index(before: str.endIndex))
        }
        return str
    }
}
