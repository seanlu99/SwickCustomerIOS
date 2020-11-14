//
//  ToCookView.swift
//  Swick
//
//  Created by Sean Lu on 10/14/20.
//

import SwiftUI
import PusherSwift
import SwiftyJSON

struct ToCookView: View {
    // Initial
    @State var isLoading = true
    // Events
    @State var viewDidBind = false
    @State var events = [(String, String?)]()
    // Alerts
    @State var showAlert = false
    // Properties
    @State var items = [OrderItem]()
    
    func loadOrderItems() {
        API.getOrderItemsToCook { json in
            if (json["status"] == "success") {
                items = []
                let itemJsonList = json["order_items"].array ?? []
                for itemJson in itemJsonList {
                    items.append(OrderItem(itemJson))
                }
            }
            else {
                showAlert = true
            }
            isLoading = false
        }
    }
    
    func bindListeners() {
        if !viewDidBind {
            viewDidBind = true
            var callbackId = PusherObj.shared.channelBind(eventName: "order-placed") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    let itemJsonList = json["order_items"].array ?? []
                    for itemJson in itemJsonList {
                        let newItem = OrderItem(itemJson)
                        items.insert(newItem, at: Helper.findUpperBound(newItem, items))
                    }
                }
            }
            events.append(("order-placed", callbackId))
            callbackId = PusherObj.shared.channelBind(eventName: "item-status-updated") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    if let status = json["status"].string,
                       let id = json["id"].int {
                        if status == "COOKING" {
                            let updatedItem = OrderItem(json["order_item"])
                            items.insert(updatedItem, at: Helper.findUpperBound(updatedItem, items))
                        }
                        else if let indexRemove = items.firstIndex(where: { $0.id == id}) {
                            items.remove(at: indexRemove)
                        }
                    }
                }
            }
            events.append(("item-status-updated", callbackId))
            PusherObj.shared.reload = loadOrderItems
        }
    }
    
    func unbindListeners() {
        for event in events {
            if let callbackId = event.1 {
                PusherObj.shared.channelUnbind(eventName: event.0, callbackId: callbackId)
            }
        }
        events.removeAll()
        viewDidBind = false
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { i in
                    ToCookRow(item: i)
                }
            }
            .if(items.count > 0) {
                $0.animation(.default)
            }
            .navigationBarTitle(Text("To Cook"))
            .onAppear {
                loadOrderItems()
                bindListeners()
            }
            .onDisappear {
                unbindListeners()
            }
            .loadingView($isLoading)
            .alert(isPresented: $showAlert) {
                return Alert(
                    title: Text("Error"),
                    message: Text("Failed to load orders. Please try again.")
                )
            }
        }
    }
}

struct ToCookView_Previews: PreviewProvider {
    static var previews: some View {
        ToCookView(isLoading: false, items: testOrderItems)
    }
}
