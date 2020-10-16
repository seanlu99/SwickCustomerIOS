//
//  Helper.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI
import SwiftyJSON

// Helper methods
class Helper {

    // Format decimal as price
    static func formatPrice(_ price: Decimal) -> String {
        var rounded = Decimal()
        var price = price 
        NSDecimalRound(&rounded, &price, 2, .plain)

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return "\(formatter.string(from: price as NSDecimalNumber) ?? "")"
    }

    // Convert string to date
    static func convertStringToDate(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: str) ?? Date()
    }

    // Convert date to string
    static func convertDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy h:mma"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }

    // Test if email is valid
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // Convert customizations JSON array to array
    static func convertCustomizationsJson(_ json: [JSON]) -> [Customization] {
        // Build customizations array
        var customizations = [Customization]()
        for cust in json {
            var c = Customization(
                id: cust["id"].int ?? 0,
                name:  cust["customization_name"].string ?? ""
            )
            // Build options array
            let optionsList = cust["options"].array ?? []
            for (i, opt) in optionsList.enumerated() {
                let o = Option(
                    id: i,
                    name: opt.string ?? ""
                )
                c.options.append(o)
            }
            customizations.append(c)
        }
        return customizations
    }
}
