//
//  RestaurantRow.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct RestaurantRow: View {
    // Properties
    var restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            RectangleImage(url: restaurant.imageUrl)
                .padding(.bottom, 10.0)
            Text(restaurant.name)
                .font(SFont.title)
                .padding(.bottom, 2.0)
            Text(restaurant.address)
                .font(SFont.body)
        }
        .padding(.vertical)
    }
}

struct RestaurantRow_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRow(restaurant: testRestaurant1)
    }
}
