//
//  VerismoApp.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

@main
struct VerismoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
#if os(macOS)
                .frame(minWidth: 800, minHeight: 535)
#endif
        }
    }
}
