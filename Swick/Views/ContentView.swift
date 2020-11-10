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
    
    func login() {
        // If no token
        if UserDefaults.standard.string(forKey: "token") == nil {
            user.screenState = .loginView
        }
        else {
            API.login() { json in
                if json["status"] == "success" {
                    user.screenState = .tabView
                }
                // If name not set
                else if !(json["name_set"].bool ?? true) {
                    user.showSetNameSheet = true
                }
                // If token invalid, remove token
                else {
                    UserDefaults.standard.removeObject(forKey: "token")
                    user.screenState = .loginView
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if user.screenState == .loadingScreen {
                GradientView()
            }
            else if user.screenState == .loginView {
                LoginView()
                    .accentColor(.white)
            }
            else {
                RootTabView()
                    // Show undismissable set name sheet if name not set
                    .sheet(isPresented: $user.showSetNameSheet) {
                        SetNameView()
                            .allowAutoDismiss { false }
                    }
            }
        }
        .onAppear(perform: login)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
