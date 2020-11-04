//
//  ThumbnailImage.swift
//  Swick
//
//  Created by Sean Lu on 10/9/20.
//

import SwiftUI
import struct Kingfisher.KFImage

struct ThumbnailImage: View {
    // Properties
    var url: String
    
    var body: some View {
        KFImage(URL(string: url))
            .cancelOnDisappear(true)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .cornerRadius(10.0)
        
    }
}

struct ThumbnailImage_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailImage(url: "https://swick-assets.s3.amazonaws.com/media/cozydiner.jpg")
    }
}
