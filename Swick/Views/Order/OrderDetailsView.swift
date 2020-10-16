//
//  OrderDetailsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct OrderDetailsView: View {
    @State var orderItems = [OrderItem]()
    @State var showOptionsActionSheet = false
    #if CUSTOMER
    @State var order: Order = Order(id: 0, time: Date(), restaurantName: "")
    #else
    @State var order: Order = Order(id: 0, time: Date(), customerName: "")
    @State var orderItemIdPressed = 0
    @State var orderItemStatusPressed = ""
    // Dummy state
    @State var showOrderDetails = false
    #endif
    var orderId: Int
    
    func loadOrderDetails() {
        API.getOrderDetails(orderId) { json in
            if (json["status"] == "success") {
                // Add to order
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
                
                // Build order items array
                orderItems = []
                let itemsList = details["order_item"].array ?? []
                for item in itemsList {
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
                Text("Table #" + (order.table ?? ""))
                #endif
                // Order time
                Text("Order placed at " +  Helper.convertDateToString(order.time))
            }
            .padding(.vertical, 10.0)
            // Items list
            ForEach(orderItems) { item in
                ItemRow(
                    quantity: item.quantity ?? 0,
                    mealName: item.mealName,
                    total: item.total,
                    customizations: item.customizations
                )
                .padding(.vertical)
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    #if SERVER
                    showOptionsActionSheet = true
                    orderItemIdPressed = item.id
                    orderItemStatusPressed = item.status ?? ""
                    #endif
                })
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
        .actionSheet(isPresented: $showOptionsActionSheet) {
            #if SERVER
            return OrderItemOptions(
                showOrderDetails: $showOrderDetails,
                orderItemId: orderItemIdPressed,
                status: orderItemStatusPressed,
                reloadItems: loadOrderDetails
            )
            .createActionSheet()
            #else
            return ActionSheet(title: Text(""))
            #endif
        }
    }
}

struct OrderDetails_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView(
            orderItems: testOrderItems,
            order: testOrder1,
            orderId: 1
        )
    }
}
