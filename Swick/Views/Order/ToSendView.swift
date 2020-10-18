//
//  ToSendView.swift
//  Swick
//
//  Created by Sean Lu on 10/14/20.
//

import SwiftUI

struct ToSendView: View {
    // Properties
    @State var items = [OrderItemOrRequest]()
    
    func loadItems() {
        API.getItemsToSend { json in
            items = []
            let itemJsonList = json.array ?? []
            for itemJson in itemJsonList {
                items.append(OrderItemOrRequest(itemJson))
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
