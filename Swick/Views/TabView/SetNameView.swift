//
//  SetNameView.swift
//  Swick
//
//  Created by Sean Lu on 10/16/20.
//

import SwiftUI

struct SetNameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var name: String = ""
    @State var showErrorAlert = false
    
    func updateName() {
        if name == "" {
            showErrorAlert = true
        }
        API.updateUserInfo(name, "") { json in
            if (json["status"] == "success") {
                // Dismiss sheet
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter your name")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20.0)
            RoundTextField(
                text: $name,
                placeholder: ""
            )
            .padding(.bottom, 20.0)
            BlueButton(text: "ENTER", action: updateName)
            Spacer()
        }
        .padding()
        .alert(isPresented: $showErrorAlert, content: {
            Alert(
                title: Text("Error"),
                message: Text("Please enter a name.")
            )
        })
    }
}

struct SetNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNameView()
    }
}
