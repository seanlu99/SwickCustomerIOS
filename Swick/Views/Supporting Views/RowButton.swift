//
//  RowButton.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct RowButton: View {
    // Properties
    var text: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RowButtonText(text: text)
        }
    }
}

struct RowButton_Previews: PreviewProvider {
    static var previews: some View {
        RowButton(text: "Add items to cart", action: {})
    }
}
