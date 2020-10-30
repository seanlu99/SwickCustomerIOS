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
    var reloadItems: () -> ()
    var item: OrderItemOrRequest
    
    func getItemId() -> Int {
        return Int(item.id.substring(fromIndex: 1)) ?? 0
    }
    
    func sendButtonPressed() {
        // If item is order item
        if item.id[0] == "O" {
            API.updateOrderItemStatus(getItemId(), "COMPLETE") { json in
                if (json["status"] == "success") {
                    reloadItems()
                }
            }
        }
        // If item is request
        else {
            deleteRequest(getItemId())
        }
    }
    
    func deleteRequest(_ requestId: Int) {
        API.deleteRequest(requestId) { json in
            if (json["status"] == "success") {
                reloadItems()
            }
        }
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
                    Text("Table #" + item.table)
                    Text(item.customerName)
                    Text(item.name)
                }
                .font(SFont.header)
                Spacer()
                SystemImage(
                    name: "arrowshape.turn.up.right.fill"
                )
                .onTapGesture(perform: sendButtonPressed)
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
                status: "Sending",
                reloadItems: reloadItems
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
                destination: OrderDetailsView(orderId: item.orderId ?? 0),
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
        ToSendRow(reloadItems: {}, item: testOrderItemOrRequest1)
    }
}
