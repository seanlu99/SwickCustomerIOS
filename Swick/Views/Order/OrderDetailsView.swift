//
//  OrderDetailsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import SwiftyJSON
import PusherSwift

struct OrderDetailsView: View {
    // Initial
    @EnvironmentObject var user: UserData
    @State var isLoading = true
    // Events
    @State var viewDidBind = false
    @State var events = [(String, String?)]()
    // Navigation
    @State var showAddTip = false
    // Alerts
    @State var showAlert = false
    // Properties
    @State var cookingOrderItems = [OrderItem]()
    @State var sendingOrderItems = [OrderItem]()
    @State var completeOrderItems = [OrderItem]()
    @State var order: Order = Order()
    var orderId: Int
    var restaurantId: Int
    var restaurantName = ""
    
    func findItem(_ id: Int,_ items: inout [OrderItem]) -> OrderItem? {
        if let indexRemove = items.firstIndex(where: { $0.id == id }) {
            return items.remove(at: indexRemove)
        }
        return nil
    }
    
    // Update lists by popping from old list and appending to new lists
    func updateItemLists(_ itemId: Int,_ status: String) {
        switch(status) {
        case "COOKING":
            if var updatedItem = findItem(itemId, &sendingOrderItems) ?? findItem(itemId, &completeOrderItems) {
                updatedItem.status = "Cooking"
                cookingOrderItems.insert(updatedItem, at: Helper.findUpperBound(updatedItem, cookingOrderItems))
            }
        case "SENDING":
            if var updatedItem = findItem(itemId, &cookingOrderItems) ?? findItem(itemId, &completeOrderItems) {
                updatedItem.status = "Sending"
                sendingOrderItems.insert(updatedItem, at: Helper.findUpperBound(updatedItem, sendingOrderItems))
            }
        case "COMPLETE":
            if var updatedItem = findItem(itemId, &cookingOrderItems) ?? findItem(itemId, &sendingOrderItems) {
                updatedItem.status = "Complete"
                completeOrderItems.insert(updatedItem, at: Helper.findUpperBound(updatedItem, completeOrderItems))
            }
        default:
            break
        }
    }

    func bindListeners() {
        if !viewDidBind {
            viewDidBind = true
            var callbackId = PusherObj.shared.channelBind(eventName: "item-status-updated") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    if let status = json["status"].string,
                       let itemId = json["id"].int {
                        updateItemLists(itemId, status)
                    }
                }
            }
            events.append(("item-status-updated", callbackId))
            callbackId = PusherObj.shared.channelBind(eventName: "tip-added-order-\(orderId)") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    if let subtotal = json["updated_subtotal"].string,
                       let tax = json["updated_tax"].string,
                       let tip = json["updated_tip"].string,
                       let total = json["updated_total"].string {
                        order.subtotal = Decimal(string: subtotal)!
                        order.tax = Decimal(string: tax)!
                        order.tip = Decimal(string: tip)
                        order.total = Decimal(string: total)!
                    }
                }
            }
            events.append(("tip-added-order-\(orderId)", callbackId))
            PusherObj.shared.reload = loadOrderDetails
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
            else {
                showAlert = true
            }
            isLoading = false
        }
    }
    
    func getNavigationBarTitle() -> Text {
        #if CUSTOMER
        return Text(restaurantName)
        #else
        return Text("Order #" + String(orderId))
        #endif
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 10.0) {
                Group {
                    #if CUSTOMER
                    Text("Order #" + String(order.id))
                    #else
                    Text("Table #" + order.table)
                    Text(order.customerName)
                    #endif
                    Text(Helper.convertDateToString(order.time))
                }
                .font(SFont.body)
            }
            .padding(.vertical, 10.0)
            // Cooking order items list
            if !cookingOrderItems.isEmpty {
                OrderItemsSection(
                    header: "COOKING",
                    items: cookingOrderItems
                )
            }
            // Sending order items list
            if !sendingOrderItems.isEmpty {
                OrderItemsSection (
                    header: "SENDING",
                    items: sendingOrderItems
                )
            }
            // Complete order items list
            if !completeOrderItems.isEmpty {
                OrderItemsSection (
                    header: "COMPLETE",
                    items: completeOrderItems
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
                RowButton(text: "Add tip") {
                    showAddTip = true
                }
            }
            #endif
        }
        .navigationBarTitle(getNavigationBarTitle())
        .onAppear {
            if user.loginState == .loggedIn {
                loadOrderDetails()
                bindListeners()
            }
            else {
                isLoading = false
            }
        }
        .onDisappear {
            if user.loginState == .loggedIn {
                unbindListeners()
            }
        }
        .loadingView($isLoading)
        .sheet(isPresented: $showAddTip) {
            #if CUSTOMER
            AddTipView(order: $order, subtotal: order.subtotal, restaurantId: restaurantId)
                .onDisappear(perform: loadOrderDetails)
            #endif
        }
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text("Failed to load order. Please try again.")
            )
        }
    }
}

struct OrderDetails_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView(
            isLoading: false,
            cookingOrderItems: testOrderItems,
            sendingOrderItems: testOrderItems,
            completeOrderItems: [],
            order: testOrder1,
            orderId: 1,
            restaurantId: 1
        )
    }
}
