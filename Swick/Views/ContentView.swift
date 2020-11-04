//
//  ContentView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct ContentView: View {
    // Initial
    @EnvironmentObject var user: UserData
    // Popups
    @State var showSetNameSheet = false
    
    init() {
        // Set navigation bar font globally
        UINavigationBar.appearance()
            .largeTitleTextAttributes = [
                .font: UIFont(name: "orkney-bold", size: 30)!
            ]
        UINavigationBar.appearance()
            .titleTextAttributes = [
                .font: UIFont(name: "orkney-bold", size: 18)!
            ]
    }
    
    func checkIfTokenSet() {
        user.hasToken = UserDefaults.standard.string(forKey: "token") != nil
    }
    
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
        Group {
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
                    .accentColor(.white)
            }
        }
        .onAppear(perform: checkIfTokenSet)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
