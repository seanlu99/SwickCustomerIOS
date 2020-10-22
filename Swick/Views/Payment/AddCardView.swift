//
//  AddCardView.swift
//  Swick
//
//  Created by Sean Lu on 10/8/20.
//

import SwiftUI
import Stripe
import UIKit

struct AddCardView: View {
    // Initial
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // Alerts
    @State var showAlert = false
    // Properties
    @State var cardParams = STPPaymentMethodCardParams()
    @State var isValid = false
    @State var attemptSetup = false
    @State var params: CardParamsWrapper?
    @State var alertMessage = ""
    
    func handleResponse(_ successful: Bool,_ message: String){
        if successful {
            presentationMode.wrappedValue.dismiss()
        }
        else {
            alertMessage = message
            showAlert = true
        }
    }
    
    var body: some View {
        VStack {
            CardTextField(cardParams: $cardParams, isValid: $isValid)
                .padding(.vertical, 15.0)
            SecondaryButton(text: "ADD"){
                if !isValid {
                    alertMessage = "Please enter a valid card"
                    showAlert = true
                }
                else {
                    params = CardParamsWrapper(cardParams)
                    attemptSetup = true
                }
            }
            .disabled(attemptSetup)
            .padding()
            CardSetupCaller(attemptSetup: $attemptSetup, cardParamsWrapper: $params, onStripeResponse: handleResponse)
                .frame(width: 0, height: 0)
            Spacer()
        }
        .navigationBarTitle("Add card")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                  message: Text(alertMessage))
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView(cardParams: STPPaymentMethodCardParams() ,isValid: false)
    }
}
