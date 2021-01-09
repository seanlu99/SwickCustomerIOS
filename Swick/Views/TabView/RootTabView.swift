//
//  RootTabView.swift
//  Swick
//
//  Created by Sean Lu on 10/16/20.
//

import SwiftUI

struct RootTabView: View {
    // Initial
    @EnvironmentObject var user: UserData
    @State var tabIndex = 0
    @Binding var hasRestaurant: Bool
    let noRestaurantMsg = "Restaurant needs to add you as a server"
    
    var body: some View {
        #if CUSTOMER
        UIKitTabView(selectedIndex: $tabIndex) {
            HomeView()
                .tab(title: "Home", image: "house.fill")
            ScanView(tabIndex: $tabIndex)
                .tab(title: "Cart", image: "cart.fill")
            OrdersView()
                .environmentObject(user)
                .tab(title: "Orders", image: "tray.full.fill")
            SettingsView()
                .environmentObject(user)
                .tab(title: "Settings", image: "gear")
        }
        #elseif SERVER
        if hasRestaurant {
            UIKitTabView {
                ToCookView()
                    .tab(title: "To cook", image: "flame.fill")
                ToSendView()
                    .tab(title: "To send", image: "arrowshape.turn.up.right.fill")
                OrdersView()
                    .environmentObject(user)
                    .tab(title: "All", image: "tray.full.fill")
                SettingsView()
                    .environmentObject(user)
                    .tab(title: "Settings", image: "gear")
            }
        }
        else {
            UIKitTabView {
                Text(noRestaurantMsg)
                    .tab(title: "To cook", image: "flame.fill")
                Text(noRestaurantMsg)
                    .tab(title: "To send", image: "arrowshape.turn.up.right.fill")
                Text(noRestaurantMsg)
                    .tab(title: "All", image: "tray.full.fill")
                SettingsView()
                    .tab(title: "Settings", image: "gear")
            }
        }
        #endif
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView(hasRestaurant: .constant(true))
    }
}
