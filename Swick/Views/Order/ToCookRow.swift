//
//  ToCookRow.swift
//  Swick
//
//  Created by Sean Lu on 10/15/20.
//

import SwiftUI

struct ToCookRow: View {
    // Popups
    @State var showOptionsActionSheet = false
    @State var showOrderDetails: Bool = false
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
                Text("Table #" + (item.table))
                    .font(.title)
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
                showOrderDetails: $showOrderDetails,
                seeFullOrder: true,
                orderItemId: item.id,
                status: "Cooking",
                reloadItems: reloadOrderItems
            )
            .createActionSheet()
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
