//
//  OrderRow.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct OrderRow: View {
    // Properties
    var order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            #if CUSTOMER
            HStack {
                Text(order.restaurantName)
                    .font(SFont.header)
                Spacer()
                Text(order.status)
                    .font(SFont.body)
            }
            #else
            HStack {
            Text("Order #" + String(order.id))
                .font(SFont.header)
                Spacer()
                Text(order.status)
                    .font(SFont.body)
            }
            Text(String(order.customerName))
                .font(SFont.body)
            #endif
            Text(Helper.convertDateToString(order.time))
                .font(SFont.body)
        }
        .padding(.vertical)
    }
}

struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: testOrder1)
    }
}
