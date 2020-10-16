//
//  LoginEmailView.swift
//  Swick
//
//  Created by Sean Lu on 10/13/20.
//

import SwiftUI

struct LoginEmailView: View {
    @State var email: String = ""
    @State var showCodeView = false
    @State var showAlert = false
    @State var alertMessage = ""
    
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
        VStack(spacing: 20.0) {
            Text("Enter your email")
                .font(.title)
            Text("We'll send you a verification code")
            RoundTextField(
                text: $email,
                placeholder: "",
                isEmail: true
            )
            .padding(.bottom, 15.0)
            BlueButton(text: "SEND", action: sendPressed)
            
            Spacer()
        }
        .padding()
        .background(Color("LightBlue").edgesIgnoringSafeArea(.all))
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
