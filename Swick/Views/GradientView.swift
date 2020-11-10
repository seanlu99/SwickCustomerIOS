//
//  GradientView.swift
//  Swick
//
//  Created by Sean Lu on 11/9/20.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
        SColor.gradient.edgesIgnoringSafeArea(.all)
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView()
    }
}
