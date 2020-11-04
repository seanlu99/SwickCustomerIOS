//
//  RectangleImage.swift
//  Swick
//
//  Created by Sean Lu on 10/9/20.
//

import SwiftUI
import struct Kingfisher.KFImage

struct RectangleImage: View {
    // Properties
    var url: String
    var width = UIScreen.width - 40
    
    var body: some View {
        KFImage(URL(string: url))
            .cancelOnDisappear(true)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: width * 3 / 5)
            .cornerRadius(10.0)
    }
}

struct RectangleImage_Previews: PreviewProvider {
    static var previews: some View {
        RectangleImage(url: "http://localhost:8000/mediafiles/icecreamshop.jpg")
    }
}
