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
    @State var viewDidLoad = false
    @State var isLoading = true
    // Alerts
    @State var showAlert = false
    // Properties
    @State var cards = [Card]()
    @Binding var selectedCard: Card?
    var cameFromCart: Bool = false
    
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
                            selectedCard = c
                            presentationMode.wrappedValue.dismiss()
                        }
                    ) {
                        CardRow(c)
                    }
                }
            }
            NavigationLink (
                destination: AddCardView()
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
                message: Text("Failed to load orders. Please try again.")
            )
        }
    }
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsView(
            isLoading: false,
            cards: testCards,
            selectedCard: .constant(nil)
        )
    }
}
