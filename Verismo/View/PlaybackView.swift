//
//  PlaybackView.swift
//  Verismo
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct PlaybackView: View {
    @EnvironmentObject var viewModel: ViewModel
    let recording: Recording
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isPortraitMode: Bool {
#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            horizontalSizeClass == .compact && verticalSizeClass == .regular
        } else {
            true
        }
#else
        true
#endif
    }
    
    @State var showingPlaybackSettings = false
    
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                if isPortraitMode {
                    NowPlayingView()
                }
                Spacer()
                LyricView(subtitlesLanguage: recording.subtitlesLanguage)
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
        .sheet(isPresented: $showingPlaybackSettings) {
            PlaybackSettingsView(dismissSheet: $showingPlaybackSettings)
                .toolbar {
#if os(macOS)
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showingPlaybackSettings = false
                        }
                    }
#endif
                }
                .presentationBackground(.thinMaterial)
                .presentationDetents([.medium, .large])
        }
    }
}

struct PlaybackControlView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var isStopActive = false
    
    var body: some View {
        let spacing = {
#if os(macOS)
            30.0
#else
            40.0
#endif
        }()
        
        HStack(spacing: spacing) {
            
            // Play/Pause Button
            Button(action: viewModel.togglePlayback) {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .contentTransition(.symbolEffect(.replace.downUp.byLayer, options: .nonRepeating))
            }
            .accessibilityLabel(viewModel.isPlaying ? "Pause" : "Play")
            .keyboardShortcut(.space, modifiers: [])
            .sensoryFeedback(.start, trigger: viewModel.isPlaying)
            
            // Stop Button
            Button(action: {
                viewModel.reset()
                isStopActive.toggle()
            })
            {
                Image(systemName: "stop.fill")
                    .symbolEffect(.bounce.down, value: isStopActive)
            }
            .accessibilityLabel("Stop")
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
    @Environment(\.accessibilityReduceMotion) var reducedMotion
    
    @AppStorage("timerTransition") var timerTransition = true
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Now Playing:")
                    Text(arias[viewModel.selectedRecording?.ariaID ?? 0].title)
                        .fontDesign(.serif)
                        .italic()
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Now Playing: \(arias[viewModel.selectedRecording?.ariaID ?? 0].title)")
                Spacer()
                Text(formattedTime(viewModel.playbackProgress))
                    .monospacedDigit()
                    .contentTransition(timerTransition ? .numericText(countsDown: false) : .identity)
                    .animation(timerTransition && !reducedMotion ? .default : .none, value: viewModel.playbackProgress)
                    .accessibility(hidden: true)
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            Slider(value: $viewModel.playbackProgress, in: 0...viewModel.totalTime, onEditingChanged: handleSliderEditingChanged)
                .padding()
                .accessibilityLabel("Playback progress")
                .accessibilityValue("\(Int(viewModel.playbackProgress) / 60) minutes, \(Int(viewModel.playbackProgress) % 60) seconds")
        }
    }
    
    func handleSliderEditingChanged(editingStarted: Bool) {
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

import Translation

struct LyricView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var configuration: TranslationSession.Configuration?
    @State var targetText = ""
    
    @State var checkLanguageAvailabilityTask: Task<Void, Never>?
    @State var previousTargetLanguage: Locale.Language?

    
    @AppStorage("lyricsFontSize") var lyricsFontSize: Double = 48.0
    
    let subtitlesLanguage: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(viewModel.currentSinger)
#if os(macOS)
                .font(.system(size: lyricsFontSize - 15))
#else
                .font(.title2)
#endif
                .padding(.top)
            
                Text(viewModel.currentLyric)
#if os(macOS)
                    .font(.system(size: lyricsFontSize))
#else
                    .font(.largeTitle)
#endif
                    .italic()
                    .fontDesign(.serif)
                    .padding()
            
            if !viewModel.subtitlesLanguageInterference {
                Text(targetText)
                    .translationTask(configuration) { session in
                        Task { @MainActor in
                            let response = try? await session.translate(viewModel.currentTranslation)
                            targetText = response?.targetText ?? viewModel.currentTranslation
                        }
                    }
#if os(macOS)
                    .font(.system(size: lyricsFontSize - 13))
#else
                    .font(.body)
#endif
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .opacity(viewModel.currentTranslation.isEmpty ? 0 : 1)
                    .cornerRadius(7)
            }
        }
        .padding()
        .onChange(of: viewModel.currentTranslation) {
            tryTranslation()
        }
        .onChange(of: viewModel.translationPossible) {
            tryTranslation()
        }
        .onChange(of: viewModel.tempSneezeTranslation) {
            tryTranslation()
        }
        // If user changes targetLanguage verify if we can proceed (pair is compatible)
        .onChange(of: viewModel.targetLanguage) {
            viewModel.translationPossible = false
            
            checkInterference()

            checkLanguageAvailabilityTask?.cancel()
            checkLanguageAvailabilityTask = Task {
                await viewModel.checkLanguageAvailability()
            }
        }
        .onAppear {
            checkInterference()
        }
        .onDisappear {
            checkLanguageAvailabilityTask?.cancel()
        }
    }
    
    func tryTranslation() {
        if viewModel.translationPossible && !viewModel.tempSneezeTranslation && !viewModel.subtitlesLanguageInterference && !viewModel.currentTranslation.isEmpty {
            triggerTranslation()
        } else {
            targetText = viewModel.currentTranslation
        }
    }
    
    func checkInterference() {
        if subtitlesLanguage == "\(viewModel.targetLanguage.languageCode ?? "")-\(viewModel.targetLanguage.region ?? "")" {
            viewModel.subtitlesLanguageInterference = true
        } else {
            viewModel.subtitlesLanguageInterference = false
        }
    }
    
    func triggerTranslation() {
        guard configuration == nil || viewModel.targetLanguage != previousTargetLanguage else {
            configuration?.invalidate()
            return
        }
        
        previousTargetLanguage = viewModel.targetLanguage
        configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en", script: nil, region: "GB"), target: viewModel.targetLanguage)
    }
}

#Preview {
    @Previewable @StateObject var model = ViewModel()
    NavigationStack {
        PlaybackView(recording: model.recordings[0]).environmentObject(model)
    }
}
