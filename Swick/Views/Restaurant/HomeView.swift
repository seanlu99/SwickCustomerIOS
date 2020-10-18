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
                ForEach(restaurants) { r in
                    NavigationLink(
                        destination: CategoriesView(restaurant: r)
                    ) {
                        RestaurantRow(restaurant: r)
                    }
                }
            }
            .navigationBarTitle(Text("Home"))
            .onAppear(perform: loadRestaurants)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(restaurants: testRestaurants)
    }
}
