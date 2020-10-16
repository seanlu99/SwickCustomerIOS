//
//  MealDetailsView.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct MealDetailsView: View {
    @EnvironmentObject var user: UserData
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var customizations = [Customization]()
    // Meal price with customization price additions
    @State var price: Decimal = 0
    @State var quantity = 1
    @State var showMinNotSelectedAlert = false
    var meal: Meal
    
    func loadMeal() {
        // Initialize price
        price = meal.price
        API.getMeal(meal.id) { json in
            if (json["status"] == "success") {
                customizations = []
                let customizationList = json["customizations"].array ?? []
                // Build customizations array
                for customization in customizationList {
                    var cust = Customization(
                        id: customization["id"].int ?? 0,
                        name:  customization["name"].string ?? "",
                        min: customization["min"].int ?? 0,
                        max: customization["max"].int ?? 0
                    )
                    // Build options array
                    let optionsList = customization["options"].array ?? []
                    let additionsList = customization["price_additions"].array ?? []
                    for (i, opt) in optionsList.enumerated() {
                        let o = opt.string ?? ""
                        let add = additionsList[i].string ?? ""
                        let a = Decimal(string: add) ?? 0
                        cust.options.append(
                            Option(
                                id: i,
                                name: o,
                                priceAddition: a,
                                isChecked: false
                            )
                        )
                    }
                    customizations.append(cust)
                }
            }
        }
    }
    
    func subtractQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    func addQuantity() {
        if quantity < 99 {
            quantity += 1
        }
    }
    
    func getTotal() -> Decimal {
        return price * Decimal(quantity)
    }
    
    func addToCart() {
        var minimumSelected = true
        for cust in customizations {
            if cust.numChecked < cust.min ?? 0 {
                minimumSelected = false
                break
            }
        }
        
        // If minimum customizations selected
        if minimumSelected {
            let cartItem = CartItem(
                id: user.cart.count,
                meal: meal,
                quantity: quantity,
                total: getTotal(),
                customizations: customizations
            )
            user.cart.append(cartItem)
            self.presentationMode.wrappedValue.dismiss()
        }
        
        // If minimum customizations not selected
        else {
            showMinNotSelectedAlert = true
        }
    }
    
    var body: some View {
        List {
            // Meal image
            RectangleImage(url: meal.imageUrl)
            // Meal description
            HStack {
                Text(meal.description)
                    .padding(.vertical)
                Spacer()
            }
            // Customizations list
            ForEach(customizations.indices, id: \.self) { i in
                CustomizationSection(
                    customization: $customizations[i],
                    price: $price
                )
            }
            HStack {
                Spacer()
                // Subtract button
                Button(action: subtractQuantity) {
                    SystemImage(name: "minus.circle.fill")
                }
                // Quantity
                Text(String(quantity))
                    .font(.title)
                    .padding(.horizontal)
                // Delete button
                Button(action: addQuantity) {
                    SystemImage(name: "plus.circle.fill")
                }
                Spacer()
            }
            .padding()
            // Add to cart button
            Button(action: addToCart) {
                ZStack(alignment: .center) {
                    Text("ADD TO CART")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    GeometryReader { geo in
                        // Total
                        Text(Helper.formatPrice(getTotal()))
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.trailing, 15.0)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .trailing)
                            .onAppear(perform: loadMeal)
                    }
                }
                .padding(.vertical, 22.5)
                .frame(maxWidth: .infinity)
                .background(Color("DarkBlue"))
                .cornerRadius(40)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .navigationBarTitle(Text(meal.name))
        .alert(isPresented: $showMinNotSelectedAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Please select minimum number of options for each customization")
            )
        }
    }
}

struct MealDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailsView(
            customizations: [testCustomization1],
            meal: testMeal1
        )
        .environmentObject(UserData())
    }
}
