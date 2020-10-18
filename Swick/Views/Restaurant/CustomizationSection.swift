//
//  CustomizationSection.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct CustomizationSection: View {
    // Properties
    @Binding var customization: Customization
    @Binding var price: Decimal
    
    var body: some View {
        Section(
            header:
                VStack(alignment: .leading, spacing: 5.0) {
                    Text(customization.name)
                    Text("min: "
                            + String(customization.min)
                            + ", max: "
                            + String(customization.max)
                    )
                }
        ) {
            ForEach(customization.options.indices, id: \.self) { i in
                OptionRow(
                    customization: $customization,
                    option: $customization.options[i],
                    price: $price
                )
            }
        }
        .padding(.vertical)
    }
}

struct CustomizationSection_Previews: PreviewProvider {
    static var previews: some View {
        CustomizationSection(
            customization: .constant(testCustomization1),
            price: .constant(0)
        )
    }
}
