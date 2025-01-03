//
//  PlaybackView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

@MainActor
struct PlaybackView: View {
    @ObservedObject var viewModel: OperaViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    let opera: LibrettoDatabase.Libretto
    
    var isPortraitMode: Bool {
#if os(iOS)
        horizontalSizeClass == .compact && verticalSizeClass == .regular
#else
        true
#endif
    }
    
    
    var body: some View {
        VStack {
            if isPortraitMode {
                NowPlaying(
                    opera: opera,
                    elapsedTime: $viewModel.playbackProgress,
                    duration: viewModel.audioPlayer?.duration ?? 0.0,
                    sliderEditingChanged: handleSliderEditingChanged
                )
            }
            Spacer()
            Lyric(
                currentSinger: viewModel.currentSinger,
                currentLyric: viewModel.currentLyric,
                englishTranslation: viewModel.currentTranslation,
                fontSize: viewModel.lyricsFontSize,
                resetPlayback: viewModel.pause,
                targetLanguage: viewModel.targetLanguage)
            .padding()
            Spacer()
            if isPortraitMode {
                PlaybackControl(viewModel: viewModel)
                #if os(macOS)
                    .shadow(radius: 5)
                #endif
            }
        }
        .padding()
    }
    
    private func handleSliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            viewModel.pause()
        } else {
            viewModel.audioPlayer?.currentTime = viewModel.playbackProgress
            viewModel.play()
        }
    }
}
