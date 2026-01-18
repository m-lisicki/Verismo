//
//  FadingText.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI

struct FadingText: ViewModifier {
    @State var opacity: Double = 0.0
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontDesign(.serif)
            .italic()
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    opacity = 1.0
                }
            }
    }
}

extension View {
    func fadingText() -> some View {
        modifier(FadingText())
    }
}
