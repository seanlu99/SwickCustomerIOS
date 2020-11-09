//
//  ToCookRow.swift
//  Swick
//
//  Created by Sean Lu on 10/15/20.
//

import SwiftUI

struct ToCookRow: View {
    // Navigation
    @State var showOptionsActionSheet = false
    @State var showOrderDetails: Bool = false
    // Alerts
    @State var showAlert = false
    // Properties
    var reloadOrderItems: () -> ()
    var item: OrderItem
    
    func cookButtonPressed() {
        API.updateOrderItemStatus(item.id, "SENDING") { json in
            if (json["status"] == "success") {
                reloadOrderItems()
            }
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10.0) {
                Text("Order #" + String(item.orderId))
                    .font(SFont.header)
                ItemRow(
                    quantity: item.quantity,
                    mealName: item.mealName,
                    customizations: item.customizations
                )
            }
            Spacer()
            SystemImage(
                name: "flame.fill"
            )
            .onTapGesture(perform: cookButtonPressed)
        }
        .padding(.vertical)
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            showOptionsActionSheet = true
        })
        // Needed to prevent navigation link from activating
        .onLongPressGesture() { }
        // Order item options action sheet
        .actionSheet(isPresented: $showOptionsActionSheet) {
            OrderItemOptions(
                showAlert: $showAlert,
                showOrderDetails: $showOrderDetails,
                seeFullOrder: true,
                orderItemId: item.id,
                status: "Cooking",
                reloadItems: reloadOrderItems
            )
            .createActionSheet()
        }
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text("Failed to update order. Please try again.")
            )
        }
        .background(
            // Navigation link to order details
            NavigationLink(
                destination: OrderDetailsView(orderId: item.orderId),
                isActive: $showOrderDetails
            ) { }
        )
    }
}

struct ToCookRow_Previews: PreviewProvider {
    static var previews: some View {
        ToCookRow(reloadOrderItems: {}, item: testOrderItem1)
    }
}
