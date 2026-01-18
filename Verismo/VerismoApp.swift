//
//  VerismoApp.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

@main
struct VerismoApp: App {
  @State var mainViewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
          NavigationStack {
            WelcomeView()
          }
          .toolbarBackground(.thinMaterial)
              .environment(mainViewModel)
#if os(macOS)
                .frame(minWidth: 800, minHeight: 535)
#endif
        }
    }
}
