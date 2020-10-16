//
//  OrdersView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct OrdersView: View {
    @State var orders = [Order]()
    
    func loadOrders() {
        API.getOrders { json in
            if (json["status"] == "success") {
                orders = []
                let orderList = json["orders"].array ?? []
                for order in orderList {
                    #if CUSTOMER
                    let o = Order(
                        id: order["id"].int ?? 0,
                        time: Helper.convertStringToDate(order["order_time"].string ?? ""),
                        status: order["status"].string ?? "",
                        restaurantName: order["restaurant_name"].string ?? ""
                    )
                    #else
                    let o = Order(
                        id: order["id"].int ?? 0,
                        time: Helper.convertStringToDate(order["order_time"].string ?? ""),
                        status: order["status"].string ?? "",
                        customerName: order["customer_name"].string ?? ""
                    )
                    #endif
                    orders.append(o)
                }
            }
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
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView(orders: testOrders)
    }
}
