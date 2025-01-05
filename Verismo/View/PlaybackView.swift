//
//  PlaybackView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct PlaybackView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
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
                NowPlayingView()
            }
            
            Spacer()
            LyricView()
            .padding()
            Spacer()
            
            if isPortraitMode {
                PlaybackControlView()
                #if os(macOS)
                    .shadow(radius: 5)
                #endif
            }
        }
        .padding()
    }
}
