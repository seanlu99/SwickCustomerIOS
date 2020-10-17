//
//  OrderItemRow.swift
//  Swick
//
//  Created by Sean Lu on 10/16/20.
//

import SwiftUI

struct OrderItemRow: View {
    @State var showOptionsActionSheet = false
    var item: OrderItem
    var reloadItems: () -> ()
    
    var body: some View {
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
            #endif
        })
        .actionSheet(isPresented: $showOptionsActionSheet) {
            #if SERVER
            return OrderItemOptions(
                showOrderDetails: .constant(false),
                orderItemId: item.id,
                status: item.status ?? "",
                reloadItems: reloadItems
            )
            .createActionSheet()
            #else
            // Unused dummy action sheet for customer
            return ActionSheet(title: Text(""))
            #endif
        }
    }
}

struct OrderItemRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemRow(item: testOrderItem1, reloadItems: {})
    }
}
