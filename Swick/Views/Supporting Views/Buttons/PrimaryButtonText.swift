//
//  PrimaryButtonText.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct PrimaryButtonText: View {
    // Properties
    var text: String
    
    var body: some View {
        Text(text)
            .font(SFont.body)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 22.5)
            .frame(maxWidth: .infinity)
            .background(SColor.primary)
            .cornerRadius(40)
    }
}

struct PrimaryButtonText_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButtonText(text: "PLACE ORDER")
    }
}
