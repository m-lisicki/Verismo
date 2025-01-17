//
//  NowPlayingView.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
import AVFoundation

struct NowPlayingView: View {
    @EnvironmentObject var viewModel: ViewModel
    @AppStorage("timerTransition") private var timerTransition = true
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Now Playing:")
                    Text(viewModel.selectedLibretto?.operaTitle ?? "")
                        .fontDesign(.serif)
                        .italic()
                }
                Spacer()
                Text(formattedTime(viewModel.playbackProgress))
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
            } else if let remotePlayer = viewModel.streamingPlayer {
                let cmTime = CMTimeMakeWithSeconds(viewModel.playbackProgress, preferredTimescale: 1)
                remotePlayer.seek(to: cmTime)
            }
            
            viewModel.play()
        }
    }
    
    let formattedTime: (TimeInterval) -> String = { String(format: "%02d:%02d", Int($0) / 60, Int($0) % 60) }
}
