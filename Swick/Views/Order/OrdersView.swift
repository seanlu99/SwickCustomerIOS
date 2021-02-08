//
//  OrdersView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import SwiftyJSON
import PusherSwift

struct OrdersView: View {
    // Initial
    @EnvironmentObject var user: UserData
    @State var isLoading = true
    // Events
    @State var viewDidBind = false
    @State var events = [(String, String?)]()
    // Alerts
    @State var showAlert = false
    // Properties
    @State var orders = [Order]()
    
    func loadOrders() {
        API.getOrders { json in
            if (json["status"] == "success") {
                orders = []
                let orderJsonList = json["orders"].array ?? []
                for orderJson in orderJsonList {
                    orders.append(Order(orderJson))
                }
            }
            else {
                showAlert = true
            }
            isLoading = false
        }
    }
    
    func bindListeners() {
        if !viewDidBind {
            viewDidBind = true
            var callbackId = PusherObj.shared.channelBind(eventName: "order-status-updated") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    if let toUpdate = orders.firstIndex(where: { $0.id == json["order_id"].int}),
                       let newStatus = json["new_status"].string {
                        orders[toUpdate].status = newStatus
                    }
                }
            }
            events.append(("order-status-updated", callbackId))
            #if SERVER
            callbackId = PusherObj.shared.channelBind(eventName: "order-placed") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    orders.insert(Order(json["order"]), at: 0)
                }
            }
            events.append(("order-placed", callbackId))
            #endif
            PusherObj.shared.reload = loadOrders
        }
    }
    
    func unbindListeners() {
        for event in events {
            if let callbackId = event.1 {
                PusherObj.shared.channelUnbind(eventName: event.0, callbackId: callbackId)
            }
        }
        events.removeAll()
        viewDidBind = false
    }
    
    var body: some View {
        NavigationView {
            Group {
                if user.loginState == .notLoggedIn || (!isLoading && orders.isEmpty) {
                    Text("No orders yet")
                        .font(SFont.header)
                        .navigationBarTitle("Orders")
                }
                else {
                    List {
                        ForEach(orders) { o in
                            NavigationLink(
                                destination: OrderDetailsView(
                                    orderId: o.id,
                                    restaurantId: o.restaurantId,
                                    restaurantName: o.restaurantName
                                )
                            ) {
                                OrderRow(order: o)
                            }
                        }
                    }
                    .if(orders.count > 0) {
                        $0.animation(.default)
                    }
                    .loadingView($isLoading)
                    .alert(isPresented: $showAlert) {
                        return Alert(
                            title: Text("Error"),
                            message: Text("Failed to load orders. Please try again.")
                        )
                    }
                }
            }
            .navigationBarTitle("Orders")
            .onAppear {
                if user.loginState == .loggedIn {
                    loadOrders()
                    bindListeners()
                }
                else {
                    isLoading = false
                }
            }
            .onDisappear{
                if user.loginState == .loggedIn {
                    unbindListeners()
                }
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(isLoading: false, orders: testOrders)
    }
}
