//
//  OrdersView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orders) { o in
                    NavigationLink(
                        destination: OrderDetailsView(orderId: o.id)
                    ) {
                        OrderRow(order: o)
                    }
                }
            }
            .navigationBarTitle("Orders")
            .onAppear(perform: loadOrders)
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
