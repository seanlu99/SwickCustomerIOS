//
//  OptionRow.swift
//  Swick
//
//  Created by Sean Lu on 10/12/20.
//

import SwiftUI

struct OptionRow: View {
    // Properties
    @Binding var customization: Customization
    @Binding var option: Option
    @Binding var price: Decimal
    
    func checkboxPressed() {
        // Check
        if option.isChecked == false {
            if customization.numChecked < customization.max ?? 0 {
                option.isChecked = true
                customization.numChecked += 1
                price += option.priceAddition ?? 0
            }
        }
        // Uncheck
        else {
            option.isChecked = false
            customization.numChecked -= 1
            price -= option.priceAddition ?? 0
        }
    }
    
    var body: some View {
        HStack {
            // Name and price
            VStack(alignment: .leading, spacing: 10.0) {
                Text(option.name)
                Text(Helper.formatPrice(option.priceAddition ?? 0))
            }
            Spacer()
            // Checkbox
            Button(action: checkboxPressed) {
                // Checked
                if option.isChecked {
                    SystemImage(
                        name: "checkmark.square",
                        width: 35.0,
                        height: 35.0
                    )
                }
                // Unchecked
                else {
                    SystemImage(
                        name: "square",
                        width: 35.0,
                        height: 35.0
                    )
                }
            }
        }
    }
}

struct OptionRow_Previews: PreviewProvider {
    static var previews: some View {
        OptionRow(
            customization: .constant(testCustomization1),
            option: .constant(testOption1),
            price: .constant(0)
        )
    }
}
