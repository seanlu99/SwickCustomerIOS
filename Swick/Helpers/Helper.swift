//
//  Helper.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI
import SwiftyJSON

// Helper methods
struct Helper {
    
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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
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
    
    static func findUpperBound<T: Comparable>(_ item: T, _ items: [T]) -> Int {
        var len = items.count
        var index = 0
        while len > 0 {
            let half = len/2
            let middle = index.advanced(by: half)
            if item >= items[middle] {
                index = middle.advanced(by: 1)
                len -= half + 1
            }
            else {
                len = half
            }
        }
        return index
    }
}

extension UIScreen {
    // Get width and height of screen
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

extension View {
    // Apply modifier conditionally
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // Dismiss keyboard from any view
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Binding {
    // onChange modifier for binding
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
            })
    }
}

// String substring extensions
// let str = "abcdef"
// str[1 ..< 3] // returns "bc"
// str[5] // returns "f"
// str[80] // returns ""
// str.substring(fromIndex: 3) // returns "def"
// str.substring(toIndex: str.length - 2) // returns "abcd"
extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
