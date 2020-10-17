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
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        user.hasToken = false
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
                        selectedCard: .constant(nil)
                    )
                ) {
                    SettingsRow(
                        imageName: "creditcard.fill",
                        text: "Payment methods"
                    )
                }
                #endif
                BlueButton(text: "LOGOUT", action: logout)
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserData())
    }
}
