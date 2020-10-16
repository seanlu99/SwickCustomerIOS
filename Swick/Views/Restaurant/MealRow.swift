//
//  MealRow.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct MealRow: View {
    var meal: Meal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10.0) {
                Text(meal.name)
                    .font(.title)
                Text(meal.description)
                    .lineLimit(1)
                Text(Helper.formatPrice(meal.price))
            }
            Spacer()
            ThumbnailImage(url: meal.imageUrl)
        }
        .padding(.vertical)
    }
}

struct MealRow_Previews: PreviewProvider {
    static var previews: some View {
        MealRow(meal: testMeal1)
    }
}
