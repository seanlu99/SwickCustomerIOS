//
//  AccountView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct AccountView: View {
    // Initial
    @State var viewDidLoad = false
    // Alerts
    @State var showAlert = false
    @State var alertMessage = ""
    // Properties
    @State var name = ""
    @State var email = ""
    #if SERVER
    @State var restaurantName = ""
    #endif
    
    func loadUserInfo() {
        if !viewDidLoad {
            viewDidLoad = true
            API.getUserInfo{ json in
                if json["status"] == "success" {
                    name = json["name"].string ?? ""
                    email = json["email"].string ?? ""
                    #if SERVER
                    restaurantName = json["restaurant_name"].string ?? ""
                    #endif
                }
            }
        }
    }
    
    func updateUserInfo() {
        // Check if name is valid
        if name == "" {
            alertMessage = "Name cannot be empty. Please try again."
            showAlert = true
            return
        }
        // Check if email is valid
        if !Helper.isValidEmail(email) {
            alertMessage = "Invalid email. Please try again."
            showAlert = true
            return
        }
        API.updateUserInfo(name, email) { json in
            if json["status"] == "success" {
                self.dismissKeyboard()
            }
            else if json["status"] == "email_already_taken" {
                alertMessage = "Email already taken. Please try a different email."
                showAlert = true
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            AccountRow(
                text: $name,
                fieldName: "Name",
                placeholder: "Enter name"
            )
            AccountRow(
                text: $email,
                fieldName: "Email",
                placeholder: "Enter email",
                isEmail: true
            )
            #if SERVER
            VStack(alignment: .leading) {
                Text("Restaurant name")
                    .font(SFont.body)
                    .fontWeight(.bold)
                    .padding(.bottom, 1.0)
                Text(restaurantName)
                    .font(SFont.body)
            }
            #endif
            SecondaryButton(text: "UPDATE", action: updateUserInfo)
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text("Account"))
        .onAppear(perform: loadUserInfo)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage)
            )
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        #if CUSTOMER
        AccountView(
            name: "John Smith",
            email: "john@gmail.com"
        )
        #else
        AccountView(
            name: "John Smith",
            email: "john@gmail.com",
            restaurantName: "The Cozy Diner"
        )
        #endif
    }
}
