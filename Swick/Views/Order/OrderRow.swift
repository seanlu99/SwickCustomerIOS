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
            HStack {
                #if CUSTOMER
                Text(order.restaurantName)
                    .font(SFont.header)
                #else
                Text(order.customerName)
                    .font(SFont.header)
                #endif
                Spacer()
                Text(order.status)
                    .font(SFont.body)
            }
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
