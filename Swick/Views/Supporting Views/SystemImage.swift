//
//  SystemImage.swift
//  Swick
//
//  Created by Sean Lu on 10/15/20.
//

import SwiftUI

struct SystemImage: View {
    // Properties
    var name: String
    var width: CGFloat = 40.0
    var height: CGFloat = 40.0
    
    var body: some View {
        Image(systemName: name)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .foregroundColor(Color("DarkBlue"))
    }
}

struct SystemImage_Previews: PreviewProvider {
    static var previews: some View {
        SystemImage(name: "flame.fill")
    }
}
