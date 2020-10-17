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
        VStack(alignment: .leading, spacing: 11.0) {
            HStack {
                #if CUSTOMER
                Text(order.restaurantName)
                    .font(.title)
                #else
                Text(order.customerName)
                    .font(.title)
                #endif
                Spacer()
                Text(order.status ?? "")
            }
            Text(Helper.convertDateToString(order.time))
                .font(.subheadline)
        }
        .padding(.vertical)
    }
}

struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: testOrder1)
    }
}
