//
//  OrderItemsSection.swift
//  Swick
//
//  Created by Sean Lu on 10/16/20.
//

import SwiftUI

struct OrderItemsSection: View {
    // Properties
    var header: String
    var items: [OrderItem]
    
    var body: some View {
        Section(
            header:
                Text(header)
                .padding(.vertical, 10.0)
        ) {
            ForEach(items) { item in
                OrderItemRow(
                    item: item
                )
            }
        }
    }
}

struct OrderItemsSection_Previews: PreviewProvider {
    static var previews: some View {
        OrderItemsSection(
            header: "COOKING",
            items: testOrderItems
        )
    }
}
