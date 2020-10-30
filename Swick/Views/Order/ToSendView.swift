//
//  ToSendView.swift
//  Swick
//
//  Created by Sean Lu on 10/14/20.
//

import SwiftUI

struct ToSendView: View {
    // Initial
    @State var isLoading = true
    // Properties
    @State var items = [OrderItemOrRequest]()
    
    func loadItems() {
        API.getItemsToSend { json in
            items = []
            let itemJsonList = json.array ?? []
            for itemJson in itemJsonList {
                items.append(OrderItemOrRequest(itemJson))
            }
            isLoading = false
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { i in
                    ToSendRow(reloadItems: loadItems, item: i)
                }
            }
            .navigationBarTitle(Text("To Send"))
            .onAppear(perform: loadItems)
            .loadingView($isLoading)
        }
    }
}

struct ToSendView_Previews: PreviewProvider {
    static var previews: some View {
        ToSendView(isLoading: false, items: testOrderItemOrRequests)
    }
}
