//
//  CustomizationsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct CustomizationsView: View {
    // Properties
    var customizations: [Customization]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(customizations) { c in
                Text(c.name)
                    .font(SFont.body)
                ForEach(c.options) { o in
                    // Only show option if customization is not checkable
                    // Or is checkable and option is checked
                    if !c.isCheckable || o.isChecked {
                        Text("- " + o.name)
                            .font(SFont.body)
                    }
                }
            }
        }
        .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
    }
}

struct CustomizationsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizationsView(customizations: testCustomizations)
    }
}
