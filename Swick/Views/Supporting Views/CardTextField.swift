//
//  CardTextField.swift
//  Swick
//
//  Created by Andrew Jiang on 10/14/20.
//

import SwiftUI
import Stripe

struct CardTextField: View {
    @Binding var cardParams: STPPaymentMethodCardParams
    @Binding var isValid: Bool
    
    var body: some View {
        StripePaymentCardTextField(cardParams: $cardParams, isValid: $isValid)
            .padding()
            .frame(width: UIScreen.width, height: 40)
    }
}

struct CardTextField_Previews: PreviewProvider {
    static var previews: some View {
        CardTextField(
            cardParams: .constant(STPPaymentMethodCardParams()),
            isValid: .constant(false)
        )
    }
}
