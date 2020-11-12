//
//  OrderItemRow.swift
//  Swick
//
//  Created by Sean Lu on 10/16/20.
//

import SwiftUI

struct OrderItemRow: View {
    // Navigation
    @State var showOptionsActionSheet = false
    // Alerts
    @State var showAlert = false
    // Properties
    var item: OrderItem
    
    var body: some View {
        // Need to force reference item.status due to iOS 13 bug
        if false { Text("\(item.status)")}
        ItemRow(
            quantity: item.quantity,
            mealName: item.mealName,
            total: item.total,
            customizations: item.customizations
        )
        .padding(.vertical)
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            #if SERVER
            showOptionsActionSheet = true
            #endif
        })
        .actionSheet(isPresented: $showOptionsActionSheet) {
            #if SERVER
            return OrderItemOptions(
                showAlert: $showAlert,
                showOrderDetails: .constant(false),
                orderItemId: item.id,
                status: item.status
            )
            .createActionSheet()
            #else
            // Unused dummy action sheet for customer
            return ActionSheet(title: Text(""))
            #endif
        }
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text("Failed to update order. Please try again.")
            )
        }
    }
}

struct OrderItemRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemRow(item: testOrderItem1)
    }
}
