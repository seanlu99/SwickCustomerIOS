//
//  RootView.swift
//  Swick
//
//  Created by Sean Lu on 10/14/20.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var user: UserData
    @State var showSetNameSheet = false
    
    func login() {
        API.login() { json in
            if json["status"] == "name_not_set" {
                showSetNameSheet = true
            }
            // If token invalid, remove token
            else if json["status"] != "success" {
                UserDefaults.standard.removeObject(forKey: "token")
                user.hasToken = false
            }
        }
    }
    
    var body: some View {
        if user.hasToken {
            RootTabView()
                .onAppear(perform: login)
                // Show undismissable set name sheet if name not set
                .sheet(isPresented: $showSetNameSheet) {
                    SetNameView()
                        .allowAutoDismiss { false }
                }
        }
        else {
            LoginView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(UserData())
    }
}
