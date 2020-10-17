//
//  TotalsView.swift
//  Swick
//
//  Created by Sean Lu on 10/9/20.
//

import SwiftUI

struct TotalsView: View {
    // Properties
    var subtotal: Decimal
    var tax: Decimal
    var tip: Decimal?
    var total: Decimal
    
    var body: some View {
        VStack {
            TotalRow(text: "Subtotal", total: subtotal)
            TotalRow(text: "Tax", total: tax)
            if let tip = tip {
                TotalRow(text: "Tip", total: tip)
            }
            TotalRow(text: "Total", total: total)
        }
    }
}

struct TotalsView_Previews: PreviewProvider {
    static var previews: some View {
        TotalsView(
            subtotal: 5.00,
            tax: 2.00,
            tip: 1.00,
            total: 8.00
        )
        TotalsView(
            subtotal: 5.00,
            tax: 2.00,
            total: 7.00
        )
    }
}
