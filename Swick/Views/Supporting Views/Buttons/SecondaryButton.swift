//
//  SecondaryButton.swift
//  Swick
//
//  Created by Sean Lu on 10/21/20.
//

import SwiftUI

struct SecondaryButton: View {
    // Properties
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            SecondaryButtonText(text: text)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(text: "PLACE ORDER", action: {})
    }
}
