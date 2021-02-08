//
//  LoginEmailView.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct LoginEmailView: View {
    // Initial
    @State var isWaiting = false
    // Navigation
    @State var showCodeView = false
    // Alerts
    @State var showAlert = false
    @State var alertMessage = ""
    // Properties
    @State var email: String = ""
    var login: () -> ()
    
    func sendPressed() {
        if !Helper.isValidEmail(email) {
            alertMessage = "Invalid email. Please try again."
            showAlert = true
            return
        }
        isWaiting = true
        API.getVerificationCode(email) { json in
            let detail = json["detail"].string ?? ""
            if detail == "A login token has been sent to your email." {
                showCodeView = true
            }
            else {
                alertMessage = "Email could not be sent. Please try again."
                showAlert = true
            }
            isWaiting = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
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
        .padding(.top, 35)
        .background(GradientView())
        // Needed to hide navigation bar on iOS 13
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .waitingView($isWaiting)
        .background(
            // Navigation link to login code view
            NavigationLink(
                destination: LoginCodeView(
                    email: email,
                    login: login
                ),
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
        LoginEmailView(login: {})
    }
}

