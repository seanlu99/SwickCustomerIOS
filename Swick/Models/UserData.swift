//
//  UserData.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

final class UserData: ObservableObject {
    @Published var loggedIn = false
    #if CUSTOMER
    @Published var cart = [CartItem]()
    #endif
}
