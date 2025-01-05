//
//  ContentView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var isConfirmationDialogPresentedBack: Bool = false
    @State var isConfirmationDialogPresentedHome: Bool = false
    
    @State private var showingPlaybackSettings = false
    
    //MARK: - Steps
    @State var chosenMode: Int?
    @State var chosenComposer: Int?
    @State var chosenOpera: String?
    
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                if viewModel.showingWelcome {
                    WelcomeView(chosenMode: $chosenMode) {
                        viewModel.continueButtonClicked()
                    }
                } else if chosenComposer == nil {
                    ComposersView(chosenComposer: $chosenComposer)
                } else if chosenOpera == nil {
                    OperasView(chosenComposer: chosenComposer, chosenOpera: $chosenOpera)
                } else if viewModel.selectedLibretto == nil {
                    PickOperaView(operaName: chosenOpera)
                } else if viewModel.audioPlayer == nil {
                    PickAndLoadAudioView()
                } else {
                    PlaybackView()
                }
                
            }
        }
        .toolbar {
            // Back Button
            ToolbarItemGroup(placement: .navigation) {
                if !viewModel.showingWelcome {
                    if viewModel.audioPlayer == nil {
                        Button(action: { toolbarIconClickedChevron.toggle(); goBack()} ) {
                            Label("Go Back", systemImage: "chevron.left")
                        }
                        .symbolEffect(.bounce.down.byLayer, options: .nonRepeating, value: toolbarIconClickedChevron)
                    } else {
                        Button(action: { isConfirmationDialogPresentedBack = true }) {
                            Label("Go Back", systemImage: "chevron.left")
                        }
                        .confirmationDialog(
                            "Are you sure you want to go back?",
                            isPresented: $isConfirmationDialogPresentedBack,
                            actions: {
                                Button("Go Back", role: .destructive) { isConfirmationDialogPresentedBack = false; goBack()}
                                    .keyboardShortcut(.defaultAction)
                                Button("Cancel", role: .cancel) {}
                                    .keyboardShortcut(.cancelAction)
                            }
                        )
                        Button(action: { isConfirmationDialogPresentedHome = true } ) {
                            Label("Go Home", systemImage: "music.note.house")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .confirmationDialog(
                            "Are you sure you want to go home?",
                            isPresented: $isConfirmationDialogPresentedHome,
                            actions: {
                                Button("Go Back", role: .destructive) { isConfirmationDialogPresentedBack = false; goHome()}
                                    .keyboardShortcut(.defaultAction)
                                Button("Cancel", role: .cancel) {}
                                    .keyboardShortcut(.cancelAction)
                            }
                        )
                    }
                }
            }
            
            // Settings Button
            ToolbarItemGroup(placement: .primaryAction) {
                if viewModel.audioPlayer != nil {
                    Button(action: {showingPlaybackSettings = true} ) {
                        Label("Playback Preferences", systemImage: "dial.medium")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
        }
        .toolbarBackground(.thinMaterial)
        .sheet(isPresented: $showingPlaybackSettings) {
            PlaybackSettingsView()
        }
        .gesture(
            DragGesture().onEnded { value in
                if viewModel.audioPlayer == nil && value.startLocation.x < 20 && value.translation.width > 50 {
                    goBack()
                }
            }
        )
        
    }
    
    @State var toolbarIconClickedChevron = false
    
    func goBack() {
        if viewModel.audioPlayer != nil {
            viewModel.resetWhileLeavingPlayback()
            viewModel.audioPlayer = nil
        } else if viewModel.selectedLibretto != nil {
            viewModel.selectedLibretto = nil
        } else if chosenOpera != nil {
            chosenOpera = nil
        } else if chosenComposer != nil {
            chosenComposer = nil
        } else {
            viewModel.showingWelcome = true
            
        }
    }
    
    func goHome() {
        viewModel.resetWhileLeavingPlayback()
        viewModel.audioPlayer = nil
        viewModel.selectedLibretto = nil
        chosenOpera = nil
        chosenComposer = nil
        viewModel.showingWelcome = true
        
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
