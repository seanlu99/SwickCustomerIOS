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
                    let restList = json["restaurants"].array ?? []
                    for rest in restList {
                        let restaurant = Restaurant(
                            id: rest["id"].int ?? 0,
                            name: rest["name"].string ?? "",
                            address: rest["address"].string ?? "",
                            imageUrl: (rest["image"].string ?? "")
                        )
                        restaurants.append(restaurant)
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
