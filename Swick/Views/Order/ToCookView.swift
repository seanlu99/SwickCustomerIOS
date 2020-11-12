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
        PusherObj.shared.channelBind(eventName: "order-placed") { (event: PusherEvent) -> Void in
            if let eventData = event.data {
                let json = JSON(eventData.data(using: .utf8) ?? "")
                let itemJsonList = json["order_items"].array ?? []
                for itemJson in itemJsonList {
                    items.insert(OrderItem(itemJson), at: 0)
                }
            }
        }
        PusherObj.shared.channelBind(eventName: "item-status-updated") { (event: PusherEvent) -> Void in
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
        PusherObj.shared.reload = loadOrderItems
    }
    
    func unbindListeners() {
        PusherObj.shared.unbindRecentEvents(2)
        PusherObj.shared.reload = nil
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
