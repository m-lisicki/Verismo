//
//  NowPlayingView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject var viewModel: ViewModel
    @AppStorage("timerTransition") private var timerTransition = true
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Now Playing:")
                    Text(viewModel.selectedLibretto!.operaTitle)
                        .fontDesign(.serif)
                        .italic()
                }
                Spacer()
                Text(formattedTime(viewModel.playbackProgress))
                    .contentTransition(timerTransition ? .numericText(countsDown: false) : .identity)
                    .animation(.default, value: viewModel.playbackProgress)
                    //.frame(width: 32, alignment: .leading)
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            Slider(value: $viewModel.playbackProgress, in: 0...(viewModel.audioPlayer?.duration ?? 0), onEditingChanged: handleSliderEditingChanged)
                .padding()
        }
    }
    
    private func handleSliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            viewModel.pause()
        } else {
            viewModel.audioPlayer?.currentTime = viewModel.playbackProgress
            viewModel.play()
        }
    }
    
    let formattedTime: (TimeInterval) -> String = { String(format: "%02d:%02d", Int($0) / 60, Int($0) % 60) }
}
