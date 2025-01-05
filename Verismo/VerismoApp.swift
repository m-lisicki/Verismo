//
//  Opera_LyricsApp.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

@main
struct VerismoApp: App {
    @StateObject private var model = ViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(model)
            }
            #if os(macOS)
            .frame(minWidth: 800, minHeight: 530)
            #endif
        }
        .windowResizability(.contentSize)
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
