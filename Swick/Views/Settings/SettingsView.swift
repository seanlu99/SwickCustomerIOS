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
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        user.screenState = .loginView
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
                NavigationLink(destination: AccountView()) {
                    SettingsRow(
                        imageName: "person.circle.fill",
                        text: "Account"
                    )
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
