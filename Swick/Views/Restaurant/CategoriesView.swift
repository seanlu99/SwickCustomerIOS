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
    @State var isLoading = true
    // Properties
    @State var categories = [Category]()
    @State var searchText = ""
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
                isLoading = false
            }
        }
    }
    
    var body: some View {
        List {
            SearchBar(text: $searchText, placeholder: "Search categories")
            // Display searched categories
            ForEach(categories.filter {
                searchText.isEmpty
                    || $0.name.lowercased().contains(searchText.lowercased())
            }) { c in
                // Category row
                NavigationLink(
                    destination: MealsView(
                        restaurantId: restaurant.id,
                        category: c,
                        cameFromCart: cameFromCart
                    )
                ) {
                    Text(c.name)
                        .font(SFont.header)
                        .padding(.vertical)
                }
            }
        }
        .navigationBarTitle(Text(restaurant.name))
        .onAppear(perform: loadCategories)
        .loadingView($isLoading)
        .resignKeyboardOnDragGesture() // for search
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(
            isLoading: false,
            categories: testCategories,
            restaurant: testRestaurant1
        )
    }
}
