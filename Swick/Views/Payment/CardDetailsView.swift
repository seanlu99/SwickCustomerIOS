//
//  CardDetailsView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import Stripe.STPImageLibrary

struct CardDetailsView: View {
    // Initial
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isWaiting = false
    // Alerts
    @State var showAlert = false
    @State var alertMessage = ""
    // Properties
    @State var attemptDelete = false
    var card: Card
    var cardImage: UIImage
    
    init(card: Card) {
        self.card = card
        self.cardImage = STPImageLibrary.brandImage(for: STPCard.brand(from: card.brand))
    }
    
    func deleteCard() {
        isWaiting = true
        attemptDelete = true
        API.removeUserCard(card.id) { json in
            if json["status"] == "success" {
                presentationMode.wrappedValue.dismiss()
            }
            else {
                alertMessage = "Failed to delete card. Please try again."
                attemptDelete = false
                showAlert = true
            }
            isWaiting = false
        }
    }
    
    func formatExpDate() -> String{
        let expMonth = card.expMonth < 10 ? "0\(card.expMonth)" : "\(card.expMonth)"
        return "\(expMonth)/\(card.expYear)"
    }
    
    var body: some View {
            VStack {
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 10){
                        Text(card.brand.capitalized)
                            .font(SFont.title)
                        Text("****\(card.last4)")
                            .font(SFont.body)
                        Text("\(formatExpDate())")
                            .font(SFont.body)
                    }
                    Spacer()
                    Image(uiImage: cardImage).resizable().frame(width: 55, height: 35)
                }.padding()
                SecondaryButton(text: "DELETE", action: deleteCard)
                    .padding()
                Spacer()
            }
            .navigationBarTitle("Card details")
            .waitingView($isWaiting)
            .alert(isPresented: $showAlert){
                Alert(title: Text("Error"),
                      message: Text(alertMessage))
            }
        }
}

struct CardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailsView(card: testCard1)
    }
}
