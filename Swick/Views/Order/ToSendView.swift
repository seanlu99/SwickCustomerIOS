//
//  ToSendView.swift
//  Swick
//
//  Created by Sean Lu on 10/14/20.
//

import SwiftUI
import SwiftyJSON
import PusherSwift

struct ToSendView: View {
    // Initial
    @State var isLoading = true
    // Events
    @State var viewDidBind = false
    @State var events = [(String, String?)]()
    // Alerts
    @State var showAlert = false
    // Properties
    @State var items = [OrderItemOrRequest]()
    
    func loadItems() {
        API.getItemsToSend { json in
            items = []
            if let itemJsonList = json.array {
                for itemJson in itemJsonList {
                    items.append(OrderItemOrRequest(itemJson))
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
            var callbackId = PusherObj.shared.channelBind(eventName: "item-status-updated") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    if let status = json["status"].string,
                       let idInt = json["id"].int{
                        let id = "O" + String(idInt)
                        if status == "SENDING" {
                            let updatedItem = OrderItemOrRequest(json["order_item"])
                            items.insert(updatedItem, at: Helper.findUpperBound(updatedItem, items))
                        }
                        else if let indexRemove = items.firstIndex(where: { $0.id == id}) {
                            items.remove(at: indexRemove)
                        }
                    }
                }
            }
            events.append(("item-status-updated", callbackId))
            callbackId = PusherObj.shared.channelBind(eventName: "request-made") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    let newRequest = OrderItemOrRequest(json["request"])
                    items.insert(newRequest, at: Helper.findUpperBound(newRequest, items))
                }
            }
            events.append(("request-made", callbackId))
            callbackId = PusherObj.shared.channelBind(eventName: "request-deleted") { (event: PusherEvent) -> Void in
                if let eventData = event.data {
                    let json = JSON(eventData.data(using: .utf8) ?? "")
                    if let requestId = json["request_id"].int {
                        let id = "R" + String(requestId)
                        if let indexRemove = items.firstIndex(where: { $0.id == id}) {
                            items.remove(at: indexRemove)
                        }
                    }
                }
            }
            events.append(("request-deleted", callbackId))
            PusherObj.shared.reload = loadItems
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
                    ToSendRow(item: i)
                }
            }
            .if(items.count > 0) {
                $0.animation(.default)
            }
            .navigationBarTitle(Text("To Send"))
            .onAppear {
                loadItems()
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

struct ToSendView_Previews: PreviewProvider {
    static var previews: some View {
        ToSendView(isLoading: false, items: testOrderItemOrRequests)
    }
}
