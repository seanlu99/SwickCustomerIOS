//
//  CustomizationsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI

struct CustomizationsView: View {
    var customizations: [Customization]
    
    var body: some View {
        VStack {
            ForEach(customizations) { c in
                VStack(alignment: .leading) {
                    // Only display customization if at least 1 option is checked
                    if c.numChecked > 0 {
                        Text(c.name)
                    }
                    ForEach(c.options, id: \.name) { o in
                        // Only display checked options
                        if o.isChecked {
                        Text("- " + o.name)
                            .font(.subheadline)
                        }
                    }
                }
                .lineLimit(1)
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
