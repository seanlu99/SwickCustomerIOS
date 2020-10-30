//
//  LoadingView.swift
//  Swick
//
//  Created by Sean Lu on 10/26/20.
//

import SwiftUI

struct LoadingView: ViewModifier  {
    // Properties
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isLoading ? 0 : 1)
            .overlay(ActivityIndicator(isAnimating: $isLoading))
    }
}

extension View {
    func loadingView(_ isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingView(isLoading: isLoading))
    }
}
