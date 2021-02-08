//
//  SettingsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct SettingsView: View {
    // Initial
    @EnvironmentObject var user: UserData
    // Alerts
    @State var showAlert = false
    // Properties
    @State var viewDidLoad = false
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        user.loginState = .notLoggedIn
        #if CUSTOMER
        user.card = nil
        #endif
        PusherObj.shared.channelUnbindAll()
        PusherObj.shared.disconenct()
    }
    
    func createLogoutAlert() -> Alert {
        let yesButton = Alert.Button.default(Text("Yes"), action: logout)
        return Alert(
            title: Text("Logout"),
            message: Text("Are you sure?"),
            primaryButton: yesButton,
            secondaryButton: Alert.Button.cancel()
        )
    }
     
    var body: some View {
        NavigationView {
            List {
                if user.loginState == .notLoggedIn {
                    PrimaryButton(text: "Login / Sign up", action: {
                        user.contentViewSheet = .login
                        user.showContentViewSheet = true
                    })
                    .onAppear{ viewDidLoad = true }
                }
                else {
                    NavigationLink(destination: AccountView()) {
                        SettingsRow(
                            imageName: "person.circle.fill",
                            text: "Account"
                        )
                        .onAppear{ viewDidLoad = true }
                    }
                    #if CUSTOMER
                    NavigationLink(
                        destination: PaymentMethodsView(
                            selectedCard: .constant(nil),
                            showPaymentMethods: .constant(false)
                        )
                    ) {
                        SettingsRow(
                            imageName: "creditcard.fill",
                            text: "Payment methods"
                        )
                    }
                    #endif
                    SecondaryButton(text: "LOGOUT", action: {showAlert = true})
                }
            }
            .transition(.move(edge: .bottom))
            .animation(viewDidLoad ? .default : nil)
            .navigationBarTitle("Settings")
            .alert(isPresented: $showAlert) {
                createLogoutAlert()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserData())
    }
}
