//
//  SColor.swift
//  Swick
//
//  Created by Sean Lu on 10/22/20.
//

import SwiftUI

struct SColor {
    static let primary = Color("Red")
    static let primaryUI = UIColor(red: 230/255, green: 57/255, blue: 70/255, alpha: 1)
    static let gradient = LinearGradient(
        gradient: Gradient(colors: [primary, Color("Pink")]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
