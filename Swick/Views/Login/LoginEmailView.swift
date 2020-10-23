//
//  LoginEmailView.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct LoginEmailView: View {
    // Initial
    @Environment(\.presentationMode) var presentationMode
    // Popups
    @State var showCodeView = false
    // Alerts
    @State var showAlert = false
    @State var alertMessage = ""
    // Properties
    @State var email: String = ""
    
    func sendPressed() {
        if !Helper.isValidEmail(email) {
            alertMessage = "Invalid email. Please try again."
            showAlert = true
            return
        }
        showCodeView = true
        API.getVerificationCode(email) { json in
            let detail = json["detail"].string ?? ""
            if detail != "A login token has been sent to your email." {
                alertMessage = "Email could not be sent. Please try again."
                showAlert = true
                return
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
                Text("Enter your email")
                    .font(SFont.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 20.0)
                Text("We'll send you a verification code")
                    .font(SFont.body)
                    .foregroundColor(.white)
                    .padding(.bottom, 20.0)
                UIKitTextField("", text: $email, onCommit: sendPressed)
                    .font(SFont.headerUI!)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .returnKey(.send)
                Divider()
                    .frame(height: 2)
                    .background(Color.white)
                Spacer()
            }
            .padding()
        }
        .background(SColor.gradient.edgesIgnoringSafeArea(.all))
        // Needed to hide navigation bar on iOS 13
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .background(
            // Navigation link to login code view
            NavigationLink(
                destination: LoginCodeView(email: email),
                isActive: $showCodeView
            ) { }
        )
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text(alertMessage)
            )
        }
    }
}

struct LoginEmailView_Previews: PreviewProvider {
    static var previews: some View {
        LoginEmailView()
    }
}
