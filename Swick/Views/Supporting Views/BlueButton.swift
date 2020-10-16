//
//  BlueButton.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct BlueButton: View {
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            BlueText(text: text)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BlueButton_Previews: PreviewProvider {
    static var previews: some View {
        BlueButton(text: "PLACE ORDER", action: {})
    }
}
