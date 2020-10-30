//
//  ToCookView.swift
//  Swick
//
//  Created by Sean Lu on 10/14/20.
//

import SwiftUI

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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { i in
                    ToCookRow(reloadOrderItems: loadOrderItems, item: i)
                }
            }
            .navigationBarTitle(Text("To Cook"))
            .onAppear(perform: loadOrderItems)
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
