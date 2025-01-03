//
//  Opera_LyricsApp.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
import TipKit

@main
struct VerismoApp: App {
    @State private var translationService = TranslationService()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(translationService)
            }
        }
    }
    
    init() {
        try? Tips.configure()
        //try? Tips.resetDatastore()
    }
}
