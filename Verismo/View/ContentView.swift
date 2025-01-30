//
//  ContentView.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack() {
                ZStack {
                    BackgroundGradient()
                    WelcomeView()
                }
            }
            .environmentObject(viewModel)
        }
        .toolbarBackground(.thinMaterial)
    }
}

struct BackgroundGradient: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = true
    
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
            [.white, .white, .white,
             .red, .white, .red,
             .orange, .yellow, .orange]
            :
                [.black, .black, .black,
                 .red, .black, .red,
                 .black, .orange, .yellow],
            smoothsColors: true
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 60).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
        .ignoresSafeArea()
    }
}

struct FadingText: ViewModifier {
    @State private var opacity: Double = 0.0
    
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

#Preview {
    @Previewable @StateObject var model = ViewModel()
    ContentView()
        .environmentObject(model)
}
