//
//  OrderDetailsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import SwiftyJSON

struct OrderDetailsView: View {
    // Popups
    @State var showAddTip = false
    // Properties
    @State var cookingOrderItems = [OrderItem]()
    @State var sendingOrderItems = [OrderItem]()
    @State var completeOrderItems = [OrderItem]()
    @State var order: Order = Order()
    var orderId: Int
    
    func loadOrderDetails() {
        API.getOrderDetails(orderId) { json in
            if (json["status"] == "success") {
                // Build order
                let details = json["order_details"]
                order = Order(details)
                // Build order items arrays
                let cookingItemsJson = details["cooking_order_items"].array ?? []
                cookingOrderItems = cookingItemsJson.map { OrderItem($0) }
                let sendingItemsJson = details["sending_order_items"].array ?? []
                sendingOrderItems = sendingItemsJson.map { OrderItem($0) }
                let completeItemsJson = details["complete_order_items"].array ?? []
                completeOrderItems = completeItemsJson.map { OrderItem($0) }
            }
        }
    }
    
    func getNavigationBarTitle() -> Text {
        #if CUSTOMER
        return Text(order.restaurantName)
        #else
        return Text(order.customerName)
        #endif
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 10.0) {
                #if SERVER
                // Order table
                Text("Table #" + (order.table))
                    .font(SFont.body)
                #endif
                // Order time
                Text("Order placed at " +  Helper.convertDateToString(order.time))
                    .font(SFont.body)
            }
            .padding(.vertical, 10.0)
            // Cooking order items list
            if !cookingOrderItems.isEmpty {
                OrderItemsSection(
                    header: "COOKING",
                    items: cookingOrderItems,
                    reloadItems: loadOrderDetails
                )
            }
            // Sending order items list
            if !sendingOrderItems.isEmpty {
                OrderItemsSection (
                    header: "SENDING",
                    items: sendingOrderItems,
                    reloadItems: loadOrderDetails
                )
            }
            // Complete order items list
            if !completeOrderItems.isEmpty {
                OrderItemsSection (
                    header: "COMPLETE",
                    items: completeOrderItems,
                    reloadItems: loadOrderDetails
                )
            }
            // Totals
            TotalsView(
                subtotal: order.subtotal,
                tax: order.tax,
                tip: order.tip,
                total: order.total
            )
            #if CUSTOMER
            // Add tip to order
            // 72 hour grace period
            if order.tip == nil && order.time.addingTimeInterval(259200) > Date() {
                WhiteButton(text: "Add tip") {
                    showAddTip = true
                }
            }
            #endif
        }
        .navigationBarTitle(getNavigationBarTitle())
        .onAppear(perform: loadOrderDetails)
        .sheet(isPresented: $showAddTip) {
            #if CUSTOMER
            AddTipView(order: $order, subtotal: order.subtotal)
                .onDisappear(perform: loadOrderDetails)
            #endif
        }
    }
}

struct OrderDetails_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView(
            cookingOrderItems: testOrderItems,
            sendingOrderItems: testOrderItems,
            completeOrderItems: [],
            order: testOrder1,
            orderId: 1
        )
    }
}