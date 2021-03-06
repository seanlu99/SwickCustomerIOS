//
//  PaymentMethodsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//
import SwiftUI

struct PaymentMethodsView: View {
    // Initial
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var user: UserData
    @State var viewDidLoad = false
    @State var isLoading = true
    // Alerts
    @State var showAlert = false
    // Properties
    @State var cards = [Card]()
    // Cart specific properties
    var cameFromCart: Bool = false
    @Binding var showPaymentMethods: Bool
    
    func loadCards() {
        if !viewDidLoad {
            viewDidLoad = true
            API.getUserCards{ json in
                if (json["status"] == "success") {
                    self.cards = []
                    let cardJsonList = json["cards"].array ?? []
                    for cardJson in cardJsonList {
                        cards.append(Card(cardJson))
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
            ForEach(cards) { c in
                if !cameFromCart {
                    NavigationLink(
                        destination: CardDetailsView(card: c)
                            .onDisappear {
                                viewDidLoad = false
                                loadCards()
                            }
                    ) {
                        CardRow(c)
                    }
                }
                else {
                    Button(
                        action: {
                            user.card = c
                            showPaymentMethods.toggle()
                        }
                    ) {
                        CardRow(c)
                    }
                }
            }
            NavigationLink (
                destination: AddCardView(
                    cameFromCart: cameFromCart,
                    showPaymentMethods: $showPaymentMethods
                )
                    .onDisappear{
                        viewDidLoad = false
                        loadCards()
                    }
            ) {
                RowButtonText(text: "Add card")
            }
        }
        .navigationBarTitle("Payment methods")
        .onAppear(perform: loadCards)
        .loadingView($isLoading)
        .alert(isPresented: $showAlert) {
            return Alert(
                title: Text("Error"),
                message: Text("Failed to load cards. Please try again.")
            )
        }
    }
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsView(
            isLoading: false,
            cards: testCards,
            showPaymentMethods: .constant(false)
        )
    }
}
