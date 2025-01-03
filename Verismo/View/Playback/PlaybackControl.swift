//
//  PlaybackControls.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct PlaybackControl: View {
    @ObservedObject var viewModel: OperaViewModel
    @State private var isStopActive = false
    
    var body: some View {
        HStack(spacing: 25) {
            //Play/Pause Button
            Button(action: viewModel.togglePlayback) {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.largeTitle)
                    .contentTransition(.symbolEffect(.replace.downUp.byLayer, options: .nonRepeating))
                    .frame(width: 40, height: 40)
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
                    .frame(width: 40, height: 40)
                    .symbolEffect(.bounce.down, value: isStopActive)
            }
            .sensoryFeedback(.warning, trigger: isStopActive)
        }
        .buttonStyle(.borderless)
        .font(.largeTitle)
        .padding()
    }
}
