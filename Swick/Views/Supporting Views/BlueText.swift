//
//  BlueText.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct BlueText: View {
    // Properties
    var text: String
    
    var body: some View {
        Text(text)
            .font(SFont.body)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 22.5)
            .frame(maxWidth: .infinity)
            .background(Color("DarkBlue"))
            .cornerRadius(40)
    }
}

struct BlueText_Previews: PreviewProvider {
    static var previews: some View {
        BlueText(text: "PLACE ORDER")
    }
}
