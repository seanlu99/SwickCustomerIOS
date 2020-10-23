//
//  HomeView.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct HomeView: View {
    // Initial
    @State var viewDidLoad = false
    // Properties
    @State var restaurants = [Restaurant]()
    @State var searchText = ""
    
    func loadRestaurants() {
        if !viewDidLoad {
            viewDidLoad = true
            API.getRestaurants{ json in
                if (json["status"] == "success") {
                    restaurants = []
                    let restJsonList = json["restaurants"].array ?? []
                    for restJson in restJsonList {
                        restaurants.append(Restaurant(restJson))
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText, placeholder: "Search restaurants")
                // Display searched restaurants
                ForEach(restaurants.filter {
                    searchText.isEmpty
                        || $0.name.lowercased().contains(searchText.lowercased())
                }) { r in
                    RestaurantRow(restaurant: r)
                }
            }
            .navigationBarTitle(Text("Home"))
            .onAppear(perform: loadRestaurants)
            .resignKeyboardOnDragGesture() // for search
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(restaurants: testRestaurants)
    }
}
