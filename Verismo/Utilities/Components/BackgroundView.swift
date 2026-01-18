//
//  BackgroundView+Modifier.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI

struct ZStackBackgroundGradient<T: View>: View {
  let view: T
  
  init(@ViewBuilder view: () -> T) {
    self.view = view()
  }
  var body: some View {
    ZStack {
      BackgroundGradient()
      view
    }
  }
}

private struct BackgroundGradient: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceMotion) var reducedMotion
    @State var isAnimating = true
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [isAnimating ? 0.8 : 0.3, isAnimating ? 0.2 : 0.1], [1.0, isAnimating ? 0.5 : 0.3],
                [0.0, 1.0], [isAnimating ? 0.3 : 0.6, 1.0], [1.0, 1.0]
            ],
            colors: colorScheme == .light ?
            [   .white, .red, .white,
                .orange, .white, .yellow,
                .white, .orange, .white
            ]
            :
                [.black, .black, .black,
                 .red, .black, .red,
                 .black, .orange, .yellow],
            smoothsColors: true
        )
        .onAppear {
            if !reducedMotion {
                withAnimation(.easeInOut(duration: 60).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
        }
        .ignoresSafeArea()
    }
}
