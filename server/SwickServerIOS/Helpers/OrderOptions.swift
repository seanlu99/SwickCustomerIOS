//
//  Options.swift
//  SwickServerIOS
//
//  Created by Sean Lu on 9/30/20.
//  Copyright © 2020 Swick. All rights reserved.
//

import Foundation
import UIKit

class OrderOptions {
    
    // Create action that updates order item status
    static func createUpdateAction(_ view: UIViewController,
                                   _ orderItemId: Int,
                                   _ newStatus: String,
                                   _ title: String,
                                   _ completion: @escaping () -> ()) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { _ in
            API.updateOrderItemStatus(orderItemId, newStatus) { json in
                if (json["status"] == "success") {
                    completion()
                }
                else {
                    Helper.alert(view, message: "Failed to update order. Please restart app and try again.")
                }
            }
        }
    }
    
    // Create options alert with given actions
    static func createAlert(_ actions: [UIAlertAction]) -> UIAlertController {
        let alertView = UIAlertController(
            title: "Options",
            message: nil,
            preferredStyle: .alert
        )
        // Add given actions
        for a in actions {
            alertView.addAction(a)
        }
        // Add cancel action
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return alertView
    }
    
    // Present alert for order item with "cook" status
    // Set seeFullOrder to true to add action that segues to full order
    static func presentCookAlert(_ view: UIViewController,
                                 _ orderItemId: Int,
                                 _ seeFullOrder: Bool = false,
                                 updateCompletion: @escaping () -> ()) {
        var actions: [UIAlertAction] = []
        let sendAction = createUpdateAction(view, orderItemId, "SENDING", "Finish cooking", updateCompletion)
        let completeAction = createUpdateAction(view, orderItemId, "COMPLETE", "Finish cooking & sending", updateCompletion)
        actions.append(sendAction)
        actions.append(completeAction)
        // Create "see full order" action if necessary
        if seeFullOrder {
            let fullOrderAction = UIAlertAction(title: "See full order", style: .default) { _ in
                view.performSegue(withIdentifier: "ToCookToOrderDetails", sender: view)
            }
            actions.append(fullOrderAction)
        }
        
        let alertView = createAlert(actions)
        view.present(alertView, animated: true)
    }
    
    // Present alert for order item with "send" status
    // Set seeFullOrder to true to add action that segues to full order
    static func presentSendAlert(_ view: UIViewController,
                                 _ orderItemId: Int,
                                 _ seeFullOrder: Bool = false,
                                 completion: @escaping () -> ()) {
        var actions: [UIAlertAction] = []
        let completeAction = createUpdateAction(view, orderItemId, "COMPLETE", "Finish sending", completion)
        let cookAction = createUpdateAction(view, orderItemId, "COOKING", "Return to cook", completion)
        actions.append(completeAction)
        actions.append(cookAction)
        // Create "see full order" action if necessary
        if seeFullOrder {
            let fullOrderAction = UIAlertAction(title: "See full order", style: .default) { _ in
                view.performSegue(withIdentifier: "ToSendToOrderDetails", sender: view)
            }
            actions.append(fullOrderAction)
        }
        
        let alertView = createAlert(actions)
        view.present(alertView, animated: true)
    }
    
    // Present alert for order item with "send" status
    static func presentCompleteAlert(_ view: UIViewController,
                                     _ orderItemId: Int,
                                     completion: @escaping () -> ()) {
        var actions: [UIAlertAction] = []
        let cookAction = createUpdateAction(view, orderItemId, "COOKING", "Return to cook", completion)
        let sendAction = createUpdateAction(view, orderItemId, "SENDING", "Return to send", completion)
        actions.append(cookAction)
        actions.append(sendAction)
        
        let alertView = createAlert(actions)
        view.present(alertView, animated: true)
    }
}
