//
//  ContentView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct ContentView: View {
    // Initial
    @EnvironmentObject var user: UserData
    
    init() {
        // Set navigation bar font globally
        UINavigationBar.appearance()
            .largeTitleTextAttributes = [
                .font: UIFont(name: "orkney-bold", size: 35)!
            ]
        UINavigationBar.appearance()
            .titleTextAttributes = [
                .font: UIFont(name: "orkney-bold", size: 18)!
            ]
    }
    
    func checkIfTokenSet() {
        user.hasToken = UserDefaults.standard.string(forKey: "token") != nil
    }
    
    var body: some View {
        RootView()
            .onAppear(perform: checkIfTokenSet)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}

extension UIScreen {
    // Get width and height of screen
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

extension View {
    // Dismiss keyboard from any view
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
