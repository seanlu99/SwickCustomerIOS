//
//  CategoriesView.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct CategoriesView: View {
    @State var categories = [Category]()
    var restaurant: Restaurant
    var cameFromCart = false
    
    func loadCategories() {
        API.getCategories(restaurant.id) { json in
            if (json["status"] == "success") {
                categories = [Category(id: 0, name: "All")]
                let categoryList = json["categories"].array ?? []
                for category in categoryList {
                    let c = Category(
                        id: category["id"].int ?? 0,
                        name: category["name"].string ?? ""
                    )
                    categories.append(c)
                }
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(categories) { c in
                NavigationLink(
                    destination: MealsView(
                        restaurantId: restaurant.id,
                        category: c,
                        cameFromCart: cameFromCart
                    )
                ) {
                    Text(c.name)
                        .font(.title)
                        .padding(.vertical)
                }
            }
        }
        .navigationBarTitle(Text(restaurant.name))
        .onAppear(perform: loadCategories)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(
            categories: testCategories,
            restaurant: testRestaurant1
        )
    }
}
