//
//  RestaurantRow.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct RestaurantRow: View {
    var restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            RectangleImage(url: restaurant.imageUrl)
            Text(restaurant.name)
                .font(.title)
            Text(restaurant.address)
                .font(.subheadline)
        }
        .padding(.vertical)
    }
}

struct RestaurantRow_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRow(restaurant: testRestaurant1)
    }
}
