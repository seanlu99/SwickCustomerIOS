//
//  LoginCodeView.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct LoginCodeView: View {
    // Initial
    @EnvironmentObject var user: UserData
    // Alerts
    @State var showAlert = false
    // Properties
    @State var code: String = ""
    var email: String
    
    func enterPressed() {
        API.getToken(email, code) { json in
            let token = json["token"].string
            // If token unsuccessfully retrieved
            if token == nil {
                showAlert = true
            }
            // If token successfully retrieved
            else {
                UserDefaults.standard.set(token, forKey: "token")
                user.hasToken = true
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20.0) {
            Text("Enter verification code")
                .font(SFont.title)
                .foregroundColor(.white)
            TextField("", text: $code)
                .font(SFont.body)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            .padding(.bottom, 15.0)
            BlueButton(text: "ENTER", action: enterPressed)
            Spacer()
        }
        .padding()
        .background(SFont.gradient.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showAlert) {
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
