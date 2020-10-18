//
//  ToCookView.swift
//  Swick
//
//  Created by Sean Lu on 10/14/20.
//

import SwiftUI

struct ToCookView: View {
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
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { i in
                    ToCookRow(reloadOrderItems: loadOrderItems, item: i)
                }
            }
            //.buttonStyle(PlainButtonStyle())
            .navigationBarTitle(Text("To Cook"))
            .onAppear(perform: loadOrderItems)
        }
    }
}

struct ToCookView_Previews: PreviewProvider {
    static var previews: some View {
        ToCookView(items: testOrderItems)
    }
}
