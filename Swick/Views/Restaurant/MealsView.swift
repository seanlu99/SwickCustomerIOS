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
    // Properties
    @State var tableView: UITableView?
    @State var meals = [Meal]()
    var restaurantId: Int
    var category: Category
    var cameFromCart: Bool
    
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
            ForEach(meals) { m in
                // Only show meal details if came from cart
                if cameFromCart {
                    NavigationLink(
                        destination: MealDetailsView(meal: m)
                    ) {
                        MealRow(meal: m)
                    }
                }
                else {
                    MealRow(meal: m)
                }
            }
        }
        .navigationBarTitle(Text(category.name))
        .introspectTableView { tableView in
            self.tableView = tableView
        }
        .onAppear {
            loadMeals()
            clearTableViewSelection()
        }
        .onDisappear(perform: clearTableViewSelection)
    }
}

struct MealsView_Previews: PreviewProvider {
    static var previews: some View {
        MealsView(
            meals: testMeals,
            restaurantId: 1,
            category: testCategory1,
            cameFromCart: false
        )
    }
}
