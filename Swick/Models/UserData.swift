//
//  UserData.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

final class UserData: ObservableObject {
    enum ScreenState { case loadingScreen, loginView, tabView }
    @Published var screenState = ScreenState.loadingScreen
    @Published var showSetNameSheet = false
    // Either customer or server id
    @Published var id: Int?
    #if CUSTOMER
    @Published var cart = [CartItem]()
    // Used for assigning cart item IDs to ensure no duplicate IDs
    @Published var cartCounter = 0
    #endif
}
