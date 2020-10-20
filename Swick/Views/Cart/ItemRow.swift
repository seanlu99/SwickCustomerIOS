//
//  ItemRow.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct ItemRow: View {
    // Properties
    var quantity: Int
    var mealName: String
    var total: Decimal?
    var customizations: [Customization]
    
    var body: some View {
        HStack(alignment: .top) {
            Text(String(quantity))
                .font(SFont.header)
                .padding(.trailing, 15.0)
            VStack(alignment: .leading, spacing: 10.0) {
                Text(mealName)
                    .font(SFont.header)
                    .lineLimit(1)
                // Only show customizations if they are not checkable
                // Or are checkable and have at least 1 option checked
                if customizations.contains(
                    where: {!$0.isCheckable || $0.numChecked > 0}
                ) {
                    CustomizationsView(customizations: customizations)
                }
            }
            if let total = total {
                Spacer()
                Text(Helper.formatPrice(total))
                    .font(SFont.header)
            }
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(
            quantity: 1,
            mealName: "Cheeseburger",
            total: 8.25,
            customizations: [testCustomization1, testCustomization2]
        )
    }
}
