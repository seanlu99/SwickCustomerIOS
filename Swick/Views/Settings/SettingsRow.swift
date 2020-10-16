//
//  SettingsRow.swift
//  Swick
//
//  Created by Sean Lu on 10/9/20.
//

import SwiftUI

struct SettingsRow: View {
    var imageName: String
    var text: String
    
    var body: some View {
        HStack {
            SystemImage(name: imageName)
                .padding(.trailing, 10.0)
            Text(text)
                .font(.title)
            Spacer()
        }
        .padding(.vertical)
    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRow(
            imageName: "person.circle.fill",
            text: "Account"
        )
    }
}
