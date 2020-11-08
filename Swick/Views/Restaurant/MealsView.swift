//
//  MealsView.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI
import Introspect

struct MealsView: View {
    // Initial
    @State var viewDidLoad = false
    @State var isLoading = true
    // Alerts
    @State var showAlert = false
    // Properties
    @State var tableView: UITableView?
    @State var meals = [Meal]()
    @State var searchText = ""
    var restaurantId: Int
    var category: Category
    // Cart specific properties
    var cameFromCart: Bool
    @Binding var showMenu: Bool
    
    func loadMeals() {
        if !viewDidLoad {
            viewDidLoad = true
            API.getMeals(restaurantId, category.id) { json in
                if (json["status"] == "success") {
                    meals = []
                    let mealJsonList = json["meals"].array ?? []
                    for mealJson in mealJsonList {
                        meals.append(Meal(mealJson))
                    }
                }
                else {
                    showAlert = true
                }
                isLoading = false
            }
        }
    }
    
    // This is a iOS14 hack that prevents clicked cell background view to remain highlighted when we come back to the screen
    func clearTableViewSelection() {
        if #available(iOS 14, *){
            DispatchQueue.main.async {
                if let selectedIndexPath = self.tableView?.indexPathForSelectedRow {
                    self.tableView?.deselectRow(at: selectedIndexPath, animated: false)
                    if let selectedCell = self.tableView?.cellForRow(at: selectedIndexPath) {
                        selectedCell.setSelected(false, animated: false)
                    }
                }
            }
        }
    }
    
    var body: some View {
        List {
            SearchBar(text: $searchText, placeholder: "Search meals")
            // Display searched meals
            ForEach(meals.filter {
                searchText.isEmpty
                    || $0.name.lowercased().contains(searchText.lowercased())
            }) { m in
                // Only show meal details if came from cart
                if cameFromCart {
                    NavigationLink(
                        destination: MealDetailsView(
                            showMenu: $showMenu,
                            meal: m
                        )
                    ) {
                        MealRow(meal: m)
                    }
                }
                else {
                    MealRow(meal: m)
                }
            }
        }
        .introspectTableView { tableView in
            self.tableView = tableView
        }
        .navigationBarTitle(Text(category.name))
        .if(cameFromCart) {
            $0.closeButton($showMenu)
        }
        .onAppear {
            loadMeals()
            clearTableViewSelection()
        }
        .loadingView($isLoading)
        .onDisappear(perform: clearTableViewSelection)
        .resignKeyboardOnDragGesture() // for search
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text("Failed to load meals. Please try again.")
            )
        }
    }
}

struct MealsView_Previews: PreviewProvider {
    static var previews: some View {
        MealsView(
            isLoading: false,
            meals: testMeals,
            restaurantId: 1,
            category: testCategory1,
            cameFromCart: false,
            showMenu: .constant(false)
        )
    }
}
