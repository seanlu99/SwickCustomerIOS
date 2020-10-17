//
//  WhiteButton.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct WhiteButton: View {
    // Properties
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            WhiteText(text: text)
        }
    }
}

struct WhiteButton_Previews: PreviewProvider {
    static var previews: some View {
        WhiteButton(text: "Add items to cart", action: {})
    }
}
