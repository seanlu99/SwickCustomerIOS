//
//  AccountRow.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct AccountRow: View {
    // Properties
    @Binding var text: String
    var fieldName: String
    var placeholder: String
    var isEmail: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(fieldName)
                .font(SFont.body)
                .fontWeight(.bold)
            TextField(placeholder, text: $text)
                .font(SFont.body)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(isEmail ? .none : .words)
                .keyboardType(isEmail ? .emailAddress : .default)
        }
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(
            text: .constant("John Smith"),
            fieldName: "Name",
            placeholder: "Enter name"
        )
    }
}
