//
//  CustomerTestData.swift
//  Swick
//
//  Created by Sean Lu on 10/7/20.
//

import Foundation

// ##### SHARED TEST DATA #####

// Customization
let testOption1 = Option(
    id: 1,
    name: "Small",
    priceAddition: 0
)
let testOption2 = Option(
    id: 2,
    name: "Medium",
    priceAddition: 1
)
let testCustomization1 = Customization(
    id: 1,
    name: "Size",
    options: [testOption1, testOption2]
)
let testOption3 = Option(
    id: 3,
    name: "Lettuce",
    priceAddition: 0
)
let testOption4 = Option(
    id: 4,
    name: "Tomatoes",
    priceAddition: 0.50
)
let testCustomization2 = Customization(
    id: 2,
    name: "Toppings",
    options: [testOption3, testOption4]
)
let testCustomizations = [testCustomization1, testCustomization2]

// Order
let testOrder1 = Order(
    id: 1,
    restaurantName: "The Cozy Diner",
    customerName: "John Smith",
    table: "6",
    time: Helper.convertStringToDate("2020-01-01T9:00Z"),
    status: "Active",
    subtotal: 16.50,
    tax: 0.50,
    tip: 15,
    total: 17
)
let testOrder2 = Order(
    id: 2,
    restaurantName: "Ice Cream Shop",
    customerName: "Bob Builder",
    time: Helper.convertStringToDate("2020-01-02T9:00Z"),
    status: "Complete"
)
let testOrders = [testOrder1, testOrder2]

// ##### CUSTOMER TEST DATA #####
#if CUSTOMER

import SwiftyJSON

// Restaurant
let testRestaurant1 = Restaurant(
    id: 1,
    name: "The Cozy Diner",
    address: "1 State St, Ann Arbor, MI 48104",
    imageUrl: "https://swick-assets-test.s3.us-east-2.amazonaws.com/cozydiner.jpg"
)
let testRestaurant2 = Restaurant(
    id: 2,
    name: "Ice Cream Shop",
    address: "1 Main St, Ann Arbor, MI 48104",
    imageUrl: "https://swick-assets-test.s3.us-east-2.amazonaws.com/icecreamshop.jpg"
)

let testRestaurants = [testRestaurant1, testRestaurant2]

// Category
let testCategory1 = Category(
    id: 1,
    name: "Appetizers"
)
let testCategory2 = Category(
    id: 2,
    name: "Entrees"
)
let testCategories = [testCategory1, testCategory2]

// Meal
let testMeal1 = Meal(
    id: 1,
    name: "Cheeseburger",
    description: "1/4 pound beef",
    price: 8.25,
    tax: 6,
    imageUrl: "https://swick-assets.s3.amazonaws.com/media/cheeseburger.jpg"
)
let testMeal2 = Meal(
    id: 2,
    name: "French fries",
    description: "Classic french fries served with ketchup",
    price: 3.50,
    tax: 6,
    imageUrl: "https://swick-assets.s3.amazonaws.com/media/frenchfries.jpg"
)
let testMeals = [testMeal1, testMeal2]

// Cart
let testCartItem1 = CartItem(
    id: 1,
    meal: testMeal1,
    quantity: 1,
    total: 8.25,
    customizations: testCustomizations
)

// Order item
let testOrderItem1 = OrderItem(
    id: 1,
    mealName: "Cheeseburger",
    quantity: 2,
    total: 13.00,
    status: "Cooking",
    customizations: testCustomizations
)
let testOrderItem2 = OrderItem(
    id: 2,
    mealName: "French fries",
    quantity: 1,
    total: 3.50,
    status: "Cooking",
    customizations: testCustomizations
)
let testOrderItems = [testOrderItem1, testOrderItem2]

// Card
let testCard1 = Card(
    id: "null_method_id",
    brand: "visa",
    expMonth: 1,
    expYear: 2021,
    last4: "2142"
)

let testCard2 = Card(
    id: "null_method_id",
    brand: "visa",
    expMonth: 1,
    expYear: 2021,
    last4: "2142"
)

let testCards = [testCard1, testCard1, testCard1, testCard1]

// ##### SERVER TEST DATA #####
#else

// Order item
let testOrderItem1 = OrderItem(
    id: 1,
    mealName: "Cheeseburger",
    quantity: 2,
    total: 13.00,
    status: "Cooking",
    customizations: testCustomizations,
    orderId: 7,
    table: "1"
)
let testOrderItem2 = OrderItem(
    id: 2,
    mealName: "French fries",
    quantity: 1,
    total: 3.50,
    status: "Cooking",
    customizations: testCustomizations,
    orderId: 7,
    table: "2"
)
let testOrderItems = [testOrderItem1, testOrderItem2]

// Order item or request
let testOrderItemOrRequest1 = OrderItemOrRequest(
    id: "R1",
    table: "1",
    name: "Water",
    customerName: "John Smith"
)
let testOrderItemOrRequest2 = OrderItemOrRequest(
    id: "O1",
    table: "1",
    name: "Cheeseburger",
    customerName: "John Smith"
)
let testOrderItemOrRequests = [testOrderItemOrRequest1, testOrderItemOrRequest2]

#endif
