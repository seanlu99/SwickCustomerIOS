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
    @State var isLoading = true
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
        #if SERVER
        PusherObj.shared.channelBind(eventName: "order-placed") { (event: PusherEvent) -> Void in
            if let eventData = event.data {
                let json = JSON(eventData.data(using: .utf8) ?? "")
                orders.insert(Order(json["order"]), at: 0)
            }
        }
        #endif
        PusherObj.shared.channelBind(eventName: "order-status-updated") { (event: PusherEvent) -> Void in
            if let eventData = event.data {
                let json = JSON(eventData.data(using: .utf8) ?? "")
                if let toUpdate = orders.firstIndex(where: { $0.id == json["order_id"].int}),
                   let newStatus = json["new_status"].string {
                    orders[toUpdate].status = newStatus
                }
            }
        }
        PusherObj.shared.reload = loadOrders
    }
    
    func unbindListeners() {
        #if SERVER
        PusherObj.shared.unbindRecentEvents(1)
        #endif
        PusherObj.shared.unbindRecentEvents(1)
        PusherObj.shared.reload = nil
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orders) { o in
                    NavigationLink(
                        destination: OrderDetailsView(
                            orderId: o.id,
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
            .navigationBarTitle("Orders")
            .onAppear {
                loadOrders()
                bindListeners()
            }
            .onDisappear{
                unbindListeners()
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
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(isLoading: false, orders: testOrders)
    }
}
