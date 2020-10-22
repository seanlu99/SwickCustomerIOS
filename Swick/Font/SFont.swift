//
//  SFont.swift
//  Swick
//
//  Created by Sean Lu on 10/19/20.
//

import SwiftUI

struct SFont {
    
    static let logo = Font.custom("forma", size: 80)
    static let fontName = "orkney-regular"
    static let title = Font.custom(fontName, size: 30)
    static let header = Font.custom(fontName, size: 23)
    static let body = Font.custom(fontName, size: 17)
    
    static let gradient = LinearGradient(
        gradient: Gradient(colors: [Color("Red"), Color("Pink")]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct SFont_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello, World!")
                .font(SFont.logo)
            Text("Hello, World!$")
                .font(SFont.title)
            Text("Hello, World!")
                .font(SFont.header)
            Text("Hello, World!")
                .font(SFont.body)
        }
    }
}
