//
//  ContentView.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var showingPlaybackSettings = false
    
    var body: some View {
        ZStack {
            //BackgroundGradient()
            NavigationView() {
                ZStack {
                    BackgroundGradient()
                    WelcomeView()
                }
            }
            .environmentObject(viewModel)
        }
        .toolbar {
            // Settings Button
            ToolbarItemGroup(placement: .primaryAction) {
                if viewModel.audioPlayer != nil || viewModel.streamingPlayer != nil {
                    Button(action: { showingPlaybackSettings = true } ) {
                        Label("Playback Preferences", systemImage: "dial.medium")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
        }
        .sheet(isPresented: $showingPlaybackSettings) {
            PlaybackSettingsView()
                .onAppear {
                    Task {
                        await viewModel.prepareSupportedLanguages()
                    }
                }
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
        /*.onAppear {
         withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
         isAnimating.toggle()
         }
         }*/
        .ignoresSafeArea()
    }
}

struct FadingText: ViewModifier {
    @State private var opacity: Double = 0.0
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontDesign(.serif)
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
