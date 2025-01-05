//
//  SettingsView.swift
//  Verismo
//
//  Created by Michał Lisicki on 05/01/2025.
//


import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                GeneralSettingsView()
            }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("timerTransition") private var timerTransition = true

    var body: some View {
        Form {
            Toggle("Timer Transition Animation", isOn: $timerTransition)
        }
    }
}
