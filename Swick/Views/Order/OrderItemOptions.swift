//
//  OrderItemOptions.swift
//  Swick
//
//  Created by Sean Lu on 10/15/20.
//

import SwiftUI

struct OrderItemOptions {
    // Alerts
    @Binding var showAlert: Bool
    // Properties
    // showOrderDetails is only used if seeFullOrder is set to true
    @Binding var showOrderDetails: Bool
    var seeFullOrder: Bool = false
    var orderItemId: Int
    var status: String
    
    // Create action sheet based on status
    func createActionSheet() -> ActionSheet {
        if status == "Cooking" {
            return createCookActionSheet()
        }
        else if status == "Sending" {
            return createSendActionSheet()
        }
        else {
            return createCompleteActionSheet()
        }
    }
    
    // Create action sheet for order item with "cook" status
    private func createCookActionSheet() -> ActionSheet {
        let sendButton = createUpdateButton(
            "SENDING",
            "Finish cooking"
        )
        let completeButton = createUpdateButton(
            "COMPLETE",
            "Finish cooking & sending"
        )
        var buttons = [sendButton] + [completeButton]
        if seeFullOrder {
            buttons.append(createSeeFullOrderButton())
        }
        return createOptionsActionSheet(buttons)
    }
    
    // Create action sheet for order item with "send" status
    // Set seeFullOrder to true to add button to see full order
    private func createSendActionSheet() -> ActionSheet {
        let completeButton = createUpdateButton(
            "COMPLETE",
            "Finish sending"
        )
        let cookButton = createUpdateButton(
            "COOKING",
            "Return to cook"
        )
        var buttons = [completeButton] + [cookButton]
        if seeFullOrder {
            buttons.append(createSeeFullOrderButton())
        }
        return createOptionsActionSheet(buttons)
    }
    
    // Create action sheet for order item with "complete" status
    private func createCompleteActionSheet()
    -> ActionSheet {
        let cookButton = createUpdateButton(
            "COOKING",
            "Return to cook"
        )
        let sendButton = createUpdateButton(
            "SENDING",
            "Return to send"
        )
        return createOptionsActionSheet([cookButton] + [sendButton])
    }
    
    // Create order item options action sheet
    private func createOptionsActionSheet(_ buttons: [Alert.Button]) -> ActionSheet {
        return ActionSheet(
            title: Text("Order item options"),
            buttons: buttons + [Alert.Button.cancel()]
        )
    }
    
    // Create button that updates order item status
    private func createUpdateButton(_ newStatus: String,
                                   _ label: String) -> Alert.Button {
        return Alert.Button.default(Text(label)) {
            API.updateOrderItemStatus(orderItemId, newStatus) { _ in }
        }
    }
    
    // Create button that shows full order
    private func createSeeFullOrderButton() -> Alert.Button {
        return Alert.Button.default(Text("See full order")) {
            showOrderDetails = true
        }
    }
}
