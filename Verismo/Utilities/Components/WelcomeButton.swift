//
//  WelcomeButton.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI

struct WelcomeButton<Destination: View>: View {
    let destination: Destination
    let primaryIcon: String
    let secondaryIcon: String?
    let title: LocalizedStringKey
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 10) {
                if let secondary = secondaryIcon {
                    ZStack {
                        Image(systemName: primaryIcon)
                            .font(.title2)
                            .fontWeight(.light)
                            .hidden()
                        Image(systemName: secondary)
                            .font(.title2)
                            .fontWeight(.light)
                            .symbolRenderingMode(.hierarchical)
                    }
                } else {
                    Image(systemName: primaryIcon)
                        .font(.title2)
                        .fontWeight(.light)
                        .symbolRenderingMode(.hierarchical)
                }
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.light)
            }
            .padding()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .buttonStyle(.borderless)
        .background(.ultraThickMaterial)
        .cornerRadius(5)
    }
}
