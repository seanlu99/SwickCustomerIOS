//
//  BackButton.swift
//  Swick
//
//  Created by Sean Lu on 10/21/20.
//

import SwiftUI

struct BackButton: View {
    var color: Color
    var dismiss: () -> ()
    
    var body: some View {
        Button(action: dismiss) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(color)
                    .imageScale(.large)
                Text("Back")
                    .font(.body)
                    .foregroundColor(color)
            }
        }
        .padding([.top, .leading])
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(color: .black, dismiss: {})
    }
}
