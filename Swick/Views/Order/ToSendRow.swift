//
//  ToSendRow.swift
//  Swick
//
//  Created by Sean Lu on 10/15/20.
//

import SwiftUI

struct ToSendRow: View {
    // Navigation
    @State var showOrderItemOptionsActionSheet = false
    @State var showRequestOptionsActionSheet = false
    @State var showOrderDetails: Bool = false
    // Alerts
    @State var showAlert = false
    // Properties
    @State var sendButtonPressed = false
    var item: OrderItemOrRequest
    
    func getItemId() -> Int {
        return Int(item.id.substring(fromIndex: 1)) ?? 0
    }
    
    func sendItem() {
        if !sendButtonPressed {
            sendButtonPressed = true
        
            // If item is order item
            if item.id[0] == "O" {
                API.updateOrderItemStatus(getItemId(), "COMPLETE") { _ in }
            }
            // If item is request
            else {
                deleteRequest(getItemId())
            }
        }
    }
    
    func deleteRequest(_ requestId: Int) {
        API.deleteRequest(requestId) { _ in }
    }
    
    func createRequestOptionsActionSheet() -> ActionSheet {
        let deleteButton = Alert.Button.default(Text("Finish sending")) {
            deleteRequest(getItemId())
        }
        return ActionSheet(
            title: Text("Request options"),
            buttons: [deleteButton] + [Alert.Button.cancel()]
        )
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10.0) {
                    Group {
                    // If item is order item
                    if item.id[0] == "O" {
                        Text("Order #" + String(item.orderId ?? 0))
                    }
                    // If item is request
                    else {
                        Text("Request")
                    }
                    }
                    .font(SFont.header)
                    Group {
                    Text("Table #" + item.table)
                    Text(item.customerName)
                    Text(item.name)
                    }
                    .font(SFont.body)
                }
                Spacer()
                SystemImage(
                    name: "arrowshape.turn.up.right.fill"
                )
                .onTapGesture(perform: sendItem)
            }
        }
        .padding(.vertical)
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            // If item is order item
            if item.id[0] == "O" {
                showOrderItemOptionsActionSheet = true
            }
            // If item is request
            else {
                showRequestOptionsActionSheet = true
            }
        })
        // Needed to prevent navigation link from activating
        .onLongPressGesture() { }
        // Order item options action sheet
        .actionSheet(isPresented: $showOrderItemOptionsActionSheet) {            
            OrderItemOptions(
                showAlert: $showAlert,
                showOrderDetails: $showOrderDetails,
                seeFullOrder: true,
                orderItemId: getItemId(),
                status: "Sending"
            )
            .createActionSheet()
        }
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text("Failed to update. Please try again.")
            )
        }
        .background(
            // Navigation link to order details
            NavigationLink(
                destination: OrderDetailsView(
                    orderId: item.orderId ?? 0,
                    restaurantId: 0
                ),
                isActive: $showOrderDetails
            ) { }
            // Request options action sheet
            .actionSheet(isPresented: $showRequestOptionsActionSheet) {
                createRequestOptionsActionSheet()
            }
        )
    }
}

struct ToSendRow_Previews: PreviewProvider {
    static var previews: some View {
        ToSendRow(item: testOrderItemOrRequest1)
    }
}
