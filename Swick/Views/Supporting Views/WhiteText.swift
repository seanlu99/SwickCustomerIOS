//
//  WhiteText.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct WhiteText: View {
    // Properties
    var text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(SFont.body)
                .fontWeight(.medium)
                .foregroundColor(Color("DarkBlue"))
                .padding(.vertical, 20)
            Spacer()
        }
    }
}

struct WhiteText_Previews: PreviewProvider {
    static var previews: some View {
        WhiteText(text: "Add items to cart")
    }
}