//
//  RootTabView.swift
//  Swick
//
//  Created by Sean Lu on 10/16/20.
//

import SwiftUI

struct RootTabView: View {
    @State var tabIndex = 0
    
    var body: some View {
        #if CUSTOMER
        UIKitTabView(selectedIndex: $tabIndex) {
            HomeView()
                .tab(title: "Home", image: "house.fill")
            ScanView(tabIndex: $tabIndex)
                .tab(title: "Cart", image: "cart.fill")
            OrdersView()
                .tab(title: "Orders", image: "tray.full.fill")
            SettingsView()
                .tab(title: "Settings", image: "gear")
        }
        #else
        UIKitTabView {
            ToCookView()
                .tab(title: "To cook", image: "flame.fill")
            ToSendView()
                .tab(title: "To send", image: "arrowshape.turn.up.right.fill")
            OrdersView()
                .tab(title: "All", image: "tray.full.fill")
            SettingsView()
                .tab(title: "Settings", image: "gear")
        }
        #endif
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
