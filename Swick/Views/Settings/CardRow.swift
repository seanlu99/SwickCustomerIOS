//
//  CardRow.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import Stripe.STPImageLibrary

struct CardRow: View {
    // Properties
    var cardImage: UIImage
    var card: Card
    
    init(_ card: Card) {
        self.card = card
        self.cardImage = STPImageLibrary.brandImage(for: STPCard.brand(from: card.brand))
    }
    
    var body: some View {
        HStack{
            Image(uiImage: cardImage)
                .renderingMode(.original)
                .resizable()
                .frame(width:45, height: 30)
            Text("\(card.brand.capitalized) \(card.last4)")
            Spacer()
        }
        .padding(.vertical)
    }
}

struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
        CardRow(testCard1)
    }
}

