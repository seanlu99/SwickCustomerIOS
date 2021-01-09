//
//  SetNameView.swift
//  Swick
//
//  Created by Sean Lu on 10/16/20.
//

import SwiftUI

struct SetNameView: View {
    // Initial
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // Properties
    @State var name: String = ""
    var presentInSheet = true
    
    func updateName() {
        API.updateUserInfo(name, "") { json in
            if (json["status"] == "success") {
                // Dismiss sheet
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text("Enter your name")
                .font(SFont.title)
                .fontWeight(.bold)
            UIKitTextField("", text: $name, onCommit: updateName, presentInSheet: presentInSheet)
                .font(SFont.headerUI!)
                .disableAutocorrection(true)
                .autocapitalization(.words)
                .returnKey(.done)
            Spacer()
        }
        .padding()
        .padding(.top, 20.0)
    }
}

struct SetNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNameView()
    }
}
