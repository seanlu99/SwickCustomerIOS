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
            .foregroundColor(PRIMARY_COLOR)
            .padding(.vertical, 22.5)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(40)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(PRIMARY_COLOR, lineWidth: 2)
            )
    }
}

struct SecondaryButtonText_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButtonText(text: "PLACE ORDER")
    }
}
