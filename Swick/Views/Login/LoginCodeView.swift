//
//  LoginCodeView.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct LoginCodeView: View {
    @EnvironmentObject var user: UserData
    @State var code: String = ""
    @State var showInvalidAlert = false
    var email: String
    
    func enterPressed() {
        API.getToken(email, code) { json in
            let token = json["token"].string
            // If token unsuccessfully retrieved
            if token == nil {
                showInvalidAlert = true
            }
            // If token successfully retrieved
            else {
                UserDefaults.standard.set(token, forKey: "token")
                // Create acocunt on backend and switch to tab view
                API.createAccount { _ in
                    user.loggedIn = true
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20.0) {
            Text("Enter verfification code")
                .font(.title)
            TextField("", text: $code)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            .padding(.bottom, 15.0)
            BlueButton(text: "ENTER", action: enterPressed)
            Spacer()
        }
        .padding()
        .background(Color("LightBlue").edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showInvalidAlert) {
            return Alert(
                title: Text("Error"),
                message: Text("Invalid verfication code. Please try again.")
            )
        }
    }
}

struct LoginCodeView_Previews: PreviewProvider {
    static var previews: some View {
        LoginCodeView(email: "")
    }
}
