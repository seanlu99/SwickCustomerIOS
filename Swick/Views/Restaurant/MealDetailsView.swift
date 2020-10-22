//
//  MealDetailsView.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import SwiftUI

struct MealDetailsView: View {
    // Initial
    @EnvironmentObject var user: UserData
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var viewDidLoad = false
    // Alerts
    @State var showAlert = false
    // Properties
    @State var customizations = [Customization]()
    @State var price: Decimal = 0 // including price additions
    @State var quantity = 1
    var meal: Meal
    
    func loadMeal() {
        if !viewDidLoad {
            viewDidLoad = true
            // Initialize price
            price = meal.price
            API.getMeal(meal.id) { json in
                if (json["status"] == "success") {
                    customizations = []
                    let customizationJsonList = json["customizations"].array ?? []
                    // Build customizations array
                    for customizationJson in customizationJsonList {
                        customizations.append(
                            Customization(customizationJson, isCheckable: true)
                        )
                    }
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
            if cust.numChecked < cust.min {
                minimumSelected = false
                break
            }
        }
        
        // If minimum customizations selected
        if minimumSelected {
            let cartItem = CartItem(
                id: user.cartCounter,
                meal: meal,
                quantity: quantity,
                total: getTotal(),
                customizations: customizations
            )
            user.cart.append(cartItem)
            user.cartCounter += 1
            self.presentationMode.wrappedValue.dismiss()
        }
        
        // If minimum customizations not selected
        else {
            showAlert = true
        }
    }
    
    var body: some View {
        List {
            if meal.imageUrl != nil || meal.description != nil {
                VStack {
                    // Meal image
                    if let imageUrl = meal.imageUrl {
                        RectangleImage(url: imageUrl)
                    }
                    // Meal description
                    if let description = meal.description {
                        HStack {
                            Text(description)
                                .font(SFont.body)
                                .padding(.vertical)
                            Spacer()
                        }
                    }
                }
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
                    .font(SFont.title)
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
                        .font(SFont.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    GeometryReader { geo in
                        // Total
                        Text(Helper.formatPrice(getTotal()))
                            .font(SFont.body)
                            .foregroundColor(.white)
                            .padding(.trailing, 15.0)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .trailing)
                            // onAppear moved here because price was not being initialized in iOS 13
                            .onAppear(perform: loadMeal)
                    }
                }
                .padding(.vertical, 22.5)
                .frame(maxWidth: .infinity)
                .background(PRIMARY_COLOR)
                .cornerRadius(40)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .navigationBarTitle(Text(meal.name))
        .alert(isPresented: $showAlert) {
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
