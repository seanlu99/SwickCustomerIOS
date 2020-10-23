//
//  RowButtonText.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct RowButtonText: View {
    // Properties
    var text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(SFont.body)
                .fontWeight(.medium)
                .foregroundColor(SColor.primary)
                .padding(.vertical, 20)
            Spacer()
        }
    }
}

struct RowButtonText_Previews: PreviewProvider {
    static var previews: some View {
        RowButtonText(text: "Add items to cart")
    }
}
