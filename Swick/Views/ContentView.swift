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
    
    func checkIfTokenSet() {
        user.hasToken = UserDefaults.standard.string(forKey: "token") != nil
    }
    
    var body: some View {
        RootView()
            .onAppear(perform: checkIfTokenSet)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
