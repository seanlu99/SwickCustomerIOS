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
    // Properties
    @State var cards = [Card]()
    @Binding var selectedCard: Card?
    var cameFromCart: Bool = false
    
    func loadCards() {
        API.getUserCards{ json in
            if (json["status"] == "success") {
                self.cards = []
                let cardList = json["cards"].array ?? []
                for c in cardList {
                    let card = Card(
                        id: c["payment_method_id"].string ?? "",
                        brand: c["brand"].string ?? "",
                        expMonth: c["exp_month"].int ?? 1,
                        expYear: c["exp_year"].int ?? 1,
                        last4: c["last4"].string ?? ""
                    )
                    self.cards.append(card)
                }
                
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(cards) { c in
                if !cameFromCart {
                    NavigationLink(
                        destination: CardDetailsView(card: c)
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
            ) {
                WhiteText(text: "Add payment method")
            }
        }
        .onAppear(perform: loadCards)
        .navigationBarTitle("Payment methods")
    }
}

struct PaymentMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodsView(
            cards: testCards,
            selectedCard: .constant(nil)
        )
    }
}
