//
//  RoundTextField.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct RoundTextField: View {
    // Properties
    @Binding var text: String
    var placeholder: String
    var isEmail = false
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .disableAutocorrection(true)
            .autocapitalization(isEmail ? .none : .words)
            .keyboardType(isEmail ? .emailAddress : .default)
    }
}

struct RoundTextField_Previews: PreviewProvider {
    static var previews: some View {
        RoundTextField(
            text: .constant("john@gmail.com"),
            placeholder: "Enter email",
            isEmail: true
        )
    }
}
