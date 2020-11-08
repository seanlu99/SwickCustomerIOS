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
    // Alerts
    @State var showAlert = false
    // Properties
    @State var categories = [Category]()
    @State var searchText = ""
    var restaurant: Restaurant
    // Cart specific properties
    var cameFromCart = false
    @Binding var showMenu: Bool
    
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
                else {
                    showAlert = true
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
                        cameFromCart: cameFromCart,
                        showMenu: $showMenu
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
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text("Failed to load categories. Please try again.")
            )
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(
            isLoading: false,
            categories: testCategories,
            restaurant: testRestaurant1,
            showMenu: .constant(false)
        )
    }
}
