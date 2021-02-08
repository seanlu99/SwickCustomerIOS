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
    @State var showOrderDetails = false
    // Alerts
    @State var showAlert = false
    // Properties
    @State var cookButtonPressed = false
    var item: OrderItem
    
    func cookItem() {
        if !cookButtonPressed {
            cookButtonPressed = true
            API.updateOrderItemStatus(item.id, "SENDING") { _ in }
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
            .onTapGesture(perform: cookItem)
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
                status: "Cooking"
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
                destination: OrderDetailsView(
                    orderId: item.orderId,
                    restaurantId: 0
                ),
                isActive: $showOrderDetails
            ) { }
        )
    }
}

struct ToCookRow_Previews: PreviewProvider {
    static var previews: some View {
        ToCookRow(item: testOrderItem1)
    }
}
