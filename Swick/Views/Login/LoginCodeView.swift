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
    @Environment(\.presentationMode) var presentationMode
    @State var isWaiting = false
    // Alerts
    @State var showAlert = false
    // Properties
    @State var code: String = ""
    var email: String
    
    func onChange() {
        if code.length == 6 {
            isWaiting = true
            API.getToken(email, code) { json in
                let token = json["token"].string
                // If token unsuccessfully retrieved
                if token == nil {
                    showAlert = true
                    code = ""
                }
                // If token successfully retrieved
                else {
                    UserDefaults.standard.set(token, forKey: "token")
                    user.hasToken = true
                }
                isWaiting = false
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            BackButton(
                color: .white,
                dismiss: {presentationMode.wrappedValue.dismiss()}
            )
            VStack() {
                Text("Enter verification code")
                    .font(SFont.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 20.0)
                UIKitTextField("", text: $code, onEditingChanged: onChange)
                    .font(SFont.titleUI!)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                Divider()
                    .frame(width: 130, height: 2)
                    .background(Color.white)
                Spacer()
            }
            .padding()
        }
        .background(SColor.gradient.edgesIgnoringSafeArea(.all))
        // Needed to hide navigation bar on iOS 13
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .waitingView($isWaiting)
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
