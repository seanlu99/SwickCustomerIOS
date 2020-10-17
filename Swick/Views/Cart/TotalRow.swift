//
//  TotalRow.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct TotalRow: View {
    // Properties
    var text: String
    var total: Decimal
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Text(Helper.formatPrice(total))
        }
        .padding(.vertical, 5.0)
    }
}

struct PriceRow_Previews: PreviewProvider {
    static var previews: some View {
        TotalRow(text: "Total", total: 2.50)
    }
}
