//
//  RectangleImage.swift
//  Swick
//
//  Created by Sean Lu on 10/9/20.
//

import SwiftUI

struct RectangleImage: View {
    // Properties
    var url: String
    var width = UIScreen.width - 40
    
    var body: some View {
        AsyncImage(url: url)
            .scaledToFill()
            .frame(width: width, height: width * 2 / 3)
            .cornerRadius(10.0)
    }
}

struct RectangleImage_Previews: PreviewProvider {
    static var previews: some View {
        RectangleImage(url: "http://localhost:8000/mediafiles/icecreamshop.jpg")
    }
}
