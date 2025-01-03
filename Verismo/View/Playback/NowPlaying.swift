//
//  NowPlayingView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

struct NowPlaying: View {
    let opera: LibrettoDatabase.Libretto
    @Binding var elapsedTime: TimeInterval
    let duration: TimeInterval
    let sliderEditingChanged: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Now Playing:")
                    Text(opera.operaTitle)
                        .fontDesign(.serif)
                        .italic()
                }
                Spacer()
                Text(formattedTime(elapsedTime))
                    .contentTransition(.numericText())
                    //.frame(width: 32, alignment: .leading)
                    .animation(.default, value: elapsedTime)
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            Slider(value: $elapsedTime, in: 0...duration, onEditingChanged: sliderEditingChanged)
                .padding()
        }
    }
    
    let formattedTime: (TimeInterval) -> String = { String(format: "%02d:%02d", Int($0) / 60, Int($0) % 60) }
}
