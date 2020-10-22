//
//  PrimaryButton.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct PrimaryButton: View {
    // Properties
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            PrimaryButtonText(text: text)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "PLACE ORDER", action: {})
    }
}
