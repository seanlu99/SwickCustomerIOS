//
//  WhiteButton.swift
//  Swick
//
//  Created by Sean Lu on 10/21/20.
//

import SwiftUI

struct WhiteButton: View {
    // Properties
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            WhiteButtonText(text: text)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WhiteButton_Previews: PreviewProvider {
    static var previews: some View {
        WhiteButton(text: "GET STARTED", action: {})
    }
}
