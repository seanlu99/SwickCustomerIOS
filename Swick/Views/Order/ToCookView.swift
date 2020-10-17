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
                let itemsList = json["order_items"].array ?? []
                for item in itemsList {
                    let customizations = Helper.convertCustomizationsJson(item["order_item_cust"].array ?? [])
                    let orderItem = OrderItem(
                        id: item["id"].int ?? 0,
                        mealName: item["meal_name"].string ?? "",
                        quantity: item["quantity"].int ?? 0,
                        customizations: customizations,
                        orderId: item["order_id"].int ?? 0,
                        table: String(describing: item["table"].int ?? 0)
                    )
                    items.append(orderItem)
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
