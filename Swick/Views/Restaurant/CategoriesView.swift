//
//  CategoriesView.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct CategoriesView: View {
    // Initial
    @State var viewDidLoad = false
    // Properties
    @State var categories = [Category]()
    var restaurant: Restaurant
    var cameFromCart = false
    
    func loadCategories() {
        if !viewDidLoad {
            viewDidLoad = true
            API.getCategories(restaurant.id) { json in
                if (json["status"] == "success") {
                    categories = [Category(id: 0, name: "All")]
                    let categoryJsonList = json["categories"].array ?? []
                    for categoryJson in categoryJsonList {
                        categories.append(Category(categoryJson))
                    }
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
