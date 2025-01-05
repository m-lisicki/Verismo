//
//  ContentView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingPlaybackSettings = false
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                if viewModel.chosenMode == nil {
                    WelcomeView()
                } else if viewModel.chosenComposer == nil {
                    ComposersView()
                } else if viewModel.chosenOpera == nil {
                    OperasView()
                } else if viewModel.selectedLibretto == nil {
                    PickOperaView()
                } else if viewModel.audioPlayer == nil && viewModel.streamingPlayer == nil {
                    PickAndLoadAudioView()
                } else {
                    PlaybackView()
                }
            }
        }
        .toolbar {
            // Back Button
            ToolbarItemGroup(placement: .navigation) {
                if viewModel.chosenMode != nil {
                    if viewModel.audioPlayer == nil  && viewModel.streamingPlayer == nil {
                        Button(action: goBack ) {
                            Label("Go Back", systemImage: "chevron.left")
                        }
                    } else {
                        Button(action: goBack ) {
                            Label("Go Back", systemImage: "chevron.left")
                        }
                        Button(action: goHome ) {
                            Label("Go Home", systemImage: "music.note.house")
                                .symbolRenderingMode(.hierarchical)
                        }
                    }
                }
            }
            
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
        .gesture(
            DragGesture().onEnded { value in
                if viewModel.audioPlayer == nil && viewModel.streamingPlayer == nil && value.startLocation.x < 20 && value.translation.width > 50 {
                    goBack()
                }
            }
        )
        
    }
        
    func goBack() {
        if viewModel.audioPlayer != nil || viewModel.streamingPlayer != nil {
            viewModel.resetWhileLeavingPlayback()
            viewModel.audioPlayer = nil
            viewModel.streamingPlayer = nil
        } else if viewModel.selectedLibretto != nil {
            viewModel.selectedLibretto = nil
        } else if viewModel.chosenOpera != nil {
            viewModel.chosenOpera = nil
        } else if viewModel.chosenComposer != nil {
            viewModel.chosenComposer = nil
        } else {
            viewModel.chosenMode = nil
        }
    }
    
    func goHome() {
        viewModel.resetWhileLeavingPlayback()
        viewModel.audioPlayer = nil
        viewModel.streamingPlayer = nil
        viewModel.selectedLibretto = nil
        viewModel.chosenOpera = nil
        viewModel.chosenComposer = nil
        viewModel.chosenMode = nil
        
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
