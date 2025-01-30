//
//  PlaybackView.swift
//  Verismo
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct PlaybackView: View {
    @EnvironmentObject var viewModel: ViewModel
    var recording: Recording
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var isPortraitMode: Bool {
#if os(iOS)
        horizontalSizeClass == .compact && verticalSizeClass == .regular
#else
        true
#endif
    }
    
    @State private var showingPlaybackSettings = false
    
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                if isPortraitMode {
                    NowPlayingView()
                }
                Spacer()
                LyricView()
                Spacer()
                
                if isPortraitMode {
                    PlaybackControlView()
#if os(macOS)
                        .shadow(radius: 5)
#endif
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: { showingPlaybackSettings = true } ) {
                        Label("Playback Preferences", systemImage: "dial.medium")
                            .symbolEffect(.rotate.byLayer, options: .nonRepeating)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .sheet(isPresented: $showingPlaybackSettings) {
                PlaybackSettingsView(availableLanguages: viewModel.availableLanguages, targetLanguage: $viewModel.targetLanguage, translationPossible: $viewModel.translationPossible, volume: $viewModel.volume)
                    .presentationDetents([.medium, .large])
                    .onAppear {
                        Task {
                            await viewModel.prepareSupportedLanguages()
                        }
                    }
            }
            
            .onAppear {
                viewModel.selectOperaAndPlay(recording)
            }
            .onDisappear {
                viewModel.resetWhileLeavingPlayback()
            }
            .padding()
        }
    }
    
}

struct PlaybackControlView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var isStopActive = false
    
    var body: some View {
        HStack(spacing: 30) {
            
            //Play/Pause Button
            Button(action: viewModel.togglePlayback) {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .contentTransition(.symbolEffect(.replace.downUp.byLayer, options: .nonRepeating))
            }
            .keyboardShortcut(.space, modifiers: [])
            .sensoryFeedback(.start, trigger: viewModel.isPlaying)
            
            //Stop Button
            Button(action: {
                viewModel.reset()
                isStopActive.toggle()
            })
            {
                Image(systemName: "stop.fill")
                    .symbolEffect(.bounce.down, value: isStopActive)
            }
            .sensoryFeedback(.warning, trigger: isStopActive)
        }
        .fixedSize(horizontal: true, vertical: true)
        .buttonStyle(.borderless)
        .font(.largeTitle)
        .padding()
    }
}

import AVFoundation

struct NowPlayingView: View {
    @EnvironmentObject var viewModel: ViewModel
    @AppStorage("timerTransition") private var timerTransition = true
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Now Playing:")
                    Text(arias[viewModel.selectedRecording?.ariaID ?? 0].title)
                        .fontDesign(.serif)
                        .italic()
                }
                Spacer()
                Text(formattedTime(viewModel.playbackProgress))
                    .monospacedDigit()
                    .contentTransition(timerTransition ? .numericText(countsDown: false) : .identity)
                    .animation(timerTransition ? .default : .none, value: viewModel.playbackProgress)
                //.frame(width: 32, alignment: .leading)
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            Slider(value: $viewModel.playbackProgress, in: 0...viewModel.totalTime, onEditingChanged: handleSliderEditingChanged)
                .padding()
        }
    }
    
    private func handleSliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            viewModel.tempSneezeTranslation = true
            viewModel.pause()
        } else {
            viewModel.tempSneezeTranslation = false
            
            if let localPlayer = viewModel.audioPlayer {
                localPlayer.currentTime = viewModel.playbackProgress
            }
            
            viewModel.play()
        }
    }
    
    let formattedTime: (TimeInterval) -> String = { String(format: "%02d:%02d", Int($0) / 60, Int($0) % 60) }
}

@preconcurrency import Translation

struct LyricView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var configuration: TranslationSession.Configuration?
    @State private var targetText = ""
    
    @AppStorage("lyricsFontSize") var lyricsFontSize: Double = 48.0
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(viewModel.currentSinger)
#if os(macOS)
                .font(.system(size: lyricsFontSize - 15))
#else
            //.font(.system(size: lyricsFontSize - 15))
                .font(.title2)
#endif
                .padding(.top)
            
            Text(viewModel.currentLyric)
#if os(macOS)
                .font(.system(size: lyricsFontSize))
#else
            //.font(.system(size: lyricsFontSize))
                .font(.largeTitle)
#endif
                .italic()
                .fontDesign(.serif)
                .padding()
            
            Text(targetText)
#if os(macOS)
                .font(.system(size: lyricsFontSize - 13))
#else
            //.font(.system(size: lyricsFontSize - 13))
                .font(.body)
#endif
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(7)
                .opacity(viewModel.currentTranslation.isEmpty ? 0 : 1)
                .translationTask(configuration) { session in
                    let response = try? await session.translate(viewModel.currentTranslation)
                    targetText = response?.targetText ?? viewModel.currentTranslation
                }
        }
        .padding()
        //        // Start translation without waiting for the timer if model downloaded in the background
        //        .onChange(of: viewModel.translationPossible) { _, newValue in
        //            if newValue && !viewModel.currentTranslation.isEmpty {
        //                triggerTranslation()
        //            }
        //        }
        .onChange(of: viewModel.currentTranslation) {
            if viewModel.translationPossible && !viewModel.tempSneezeTranslation && !viewModel.currentTranslation.isEmpty {
                triggerTranslation()
            } else {
                targetText = viewModel.currentTranslation
            }
        }
        // If user changes targetLanguage verify if we can proceed (pair is compatible)
        .onChange(of: viewModel.targetLanguage) {
            viewModel.translationPossible = false
            configuration?.invalidate()
            configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en", region: "GB"), target: viewModel.targetLanguage)
            Task {
                await viewModel.checkLanguageAvailability()
            }
        }
    }
    
    private func triggerTranslation() {
        guard configuration == nil else {
            configuration?.invalidate()
            return
        }
        configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en",region: "GB"),
                                                         target: viewModel.targetLanguage)
    }
}

#Preview {
    //@Previewable @StateObject var model = ViewModel()
    //PlaybackView(opera: model.operas[3]).environmentObject(model)
}
