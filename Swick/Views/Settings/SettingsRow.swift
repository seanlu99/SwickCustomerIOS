//
//  SettingsRow.swift
//  Swick
//
//  Created by Sean Lu on 10/9/20.
//

import SwiftUI

struct SettingsRow: View {
    // Properties
    var imageName: String
    var text: String
    
    var body: some View {
        HStack {
            SystemImage(
                name: imageName,
                width: 35.0,
                height: 35.0
            )
                .padding(.trailing, 10.0)
            Text(text)
                .font(SFont.header)
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
