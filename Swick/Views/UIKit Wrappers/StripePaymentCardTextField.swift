//
//  StripePaymentCardTextField.swift
//  Swick
//
//  Taken from https://gist.github.com/Gujci/71eba08ec067e904f6e4b2a00f2af43d
//

import SwiftUI
import Stripe

struct StripePaymentCardTextField: UIViewRepresentable {
    
    @Binding var cardParams: STPPaymentMethodCardParams
    @Binding var isValid: Bool
    
    func makeUIView(context: Context) -> STPPaymentCardTextField {
        let input = STPPaymentCardTextField()
        input.borderWidth = 1
        input.delegate = context.coordinator
        return input
    }
    
    func makeCoordinator() -> StripePaymentCardTextField.Coordinator { Coordinator(self) }

    func updateUIView(_ view: STPPaymentCardTextField, context: Context) { }
    
    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {

        var parent: StripePaymentCardTextField
        
        init(_ textField: StripePaymentCardTextField) {
            parent = textField
        }
        
        func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            parent.cardParams = textField.cardParams
            parent.isValid = textField.isValid
        }
    }
}


// MARK: - Preview
struct StripePaymentCardTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            VStack {
                Spacer()
                StripePaymentCardTextField(cardParams: .constant(STPPaymentMethodCardParams()), isValid: .constant(true))
            }
            
            VStack {
                Spacer()
                StripePaymentCardTextField(cardParams: .constant(STPPaymentMethodCardParams()), isValid: .constant(true))
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
