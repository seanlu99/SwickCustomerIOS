//
//  ToSendView.swift
//  Swick
//
//  Created by Sean Lu on 10/14/20.
//

import SwiftUI

struct ToSendView: View {
    @State var items = [OrderItemOrRequest]()
    
    func loadItems() {
        API.getItemsToSend { json in
            items = []
            let itemsList = json.array ?? []
            for item in itemsList {
                if item["type"] == "OrderItem" {
                    let orderItem = OrderItemOrRequest(
                        id: "O" + String(describing: item["id"].int ?? 0),
                        table: String(describing: item["table"].int ?? 0),
                        name: item["meal_name"].string ?? "",
                        customerName: item["customer_name"].string ?? "",
                        orderId: item["order_id"].int ?? 0
                    )
                    items.append(orderItem)
                }
                else if item["type"] == "Request" {
                    let request = OrderItemOrRequest(
                        id: "R" + String(describing: item["id"].int ?? 0),
                        table: String(describing: item["table"].int ?? 0),
                        name: item["request_name"].string ?? "",
                        customerName: item["customer_name"].string ?? ""
                    )
                    items.append(request)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { i in
                    ToSendRow(reloadItems: loadItems, item: i)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .navigationBarTitle(Text("To Send"))
            .onAppear(perform: loadItems)
        }
    }
}

struct ToSendView_Previews: PreviewProvider {
    static var previews: some View {
        ToSendView(items: testOrderItemOrRequests)
    }
}
