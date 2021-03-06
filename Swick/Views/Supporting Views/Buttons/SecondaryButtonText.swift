//
//  SecondaryButtonText.swift
//  Swick
//
//  Created by Sean Lu on 10/21/20.
//

import SwiftUI

struct SecondaryButtonText: View {
    // Properties
    var text: String
    
    var body: some View {
        Text(text)
            .font(SFont.body)
            .fontWeight(.medium)
            .foregroundColor(SColor.primary)
            .padding(.vertical, 22.5)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(SColor.primary, lineWidth: 2)
            )
            // Needed to make button clickable everywhere
            .contentShape(RoundedRectangle(cornerRadius: 40))
    }
}

struct SecondaryButtonText_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButtonText(text: "PLACE ORDER")
    }
}
