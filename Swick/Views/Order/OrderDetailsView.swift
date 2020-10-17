//
//  OrderDetailsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import SwiftyJSON

struct OrderDetailsView: View {
    @State var cookingOrderItems = [OrderItem]()
    @State var sendingOrderItems = [OrderItem]()
    @State var completeOrderItems = [OrderItem]()
    #if CUSTOMER
    @State var order: Order = Order(id: 0, time: Date(), restaurantName: "")
    #else
    @State var order: Order = Order(id: 0, time: Date(), customerName: "")
    #endif
    var orderId: Int
    
    func loadOrderDetails() {
        API.getOrderDetails(orderId) { json in
            if (json["status"] == "success") {
                // Build order
                let details = json["order_details"]
                let subtotalStr = details["subtotal"].string ?? ""
                let taxStr = details["tax"].string ?? ""
                let totalStr = details["total"].string ?? ""
                order.time = Helper.convertStringToDate(details["time"].string ?? "")
                order.subtotal = Decimal(string: subtotalStr) ?? 0
                order.tax = Decimal(string: taxStr) ?? 0
                order.total = Decimal(string: totalStr) ?? 0
                #if CUSTOMER
                order.restaurantName = details["restaurant_name"].string ?? ""
                #else
                order.customerName = details["customer_name"].string ?? ""
                order.table = String(describing: details["table"].int ?? 0)
                #endif
                
                // Build order items arrays
                let cookingItemsJson = details["cooking_order_items"].array ?? []
                cookingOrderItems = convertOrderItemsJson(cookingItemsJson)
                let sendingItemsJson = details["sending_order_items"].array ?? []
                sendingOrderItems = convertOrderItemsJson(sendingItemsJson)
                let completeItemsJson = details["complete_order_items"].array ?? []
                completeOrderItems = convertOrderItemsJson(completeItemsJson)
            }
        }
    }
    
    func convertOrderItemsJson(_ json: [JSON]) -> [OrderItem] {
        var orderItems = [OrderItem]()
        for item in json {
            let t = item["total"].string ?? ""
            let customizations = Helper.convertCustomizationsJson(item["order_item_cust"].array ?? [])
            #if CUSTOMER
            let orderItem = OrderItem(
                id: item["id"].int ?? 0,
                mealName: item["meal_name"].string ?? "",
                quantity: item["quantity"].int ?? 0,
                total: Decimal(string: t) ?? 0,
                status:  item["status"].string ?? "",
                customizations: customizations
            )
            #else
            let orderItem = OrderItem(
                id: item["id"].int ?? 0,
                mealName: item["meal_name"].string ?? "",
                quantity: item["quantity"].int ?? 0,
                total: Decimal(string: t) ?? 0,
                status:  item["status"].string ?? "",
                customizations: customizations
            )
            #endif
            orderItems.append(orderItem)
        }
        return orderItems
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
                Text("Table #" + (order.table ?? ""))
                #endif
                // Order time
                Text("Order placed at " +  Helper.convertDateToString(order.time))
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
                subtotal: order.subtotal ?? 0,
                tax: order.tax ?? 0,
                tip: 0,
                total: order.total ?? 0
            )
        }
        .navigationBarTitle(getNavigationBarTitle())
        .onAppear(perform: loadOrderDetails)
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
