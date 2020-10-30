//
//  WaitingView.swift
//  Swick
//
//  Created by Sean Lu on 10/29/20.
//

import SwiftUI

struct WaitingView: ViewModifier {
    // Properties
    @Binding var isWaiting: Bool
    
    func body(content: Content) -> some View {
        content
            .allowsHitTesting(!isWaiting)
            .overlay(ActivityIndicator(isAnimating: $isWaiting))
    }
}

extension View {
    func waitingView(_ isWaiting: Binding<Bool>) -> some View {
        self.modifier(WaitingView(isWaiting: isWaiting))
    }
}
