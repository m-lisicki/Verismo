//
//  WelcomeView.swift
//  Verismo
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 70) {
            Text("Welcome to Verismo.")
                .fadingText()
            
            HStack(spacing: 20) {
                WelcomeButton(
                    destination: PickOperaView(),
                    primaryIcon: "music.note",
                    secondaryIcon: nil,
                    title: "Listen"
                )
                
                WelcomeButton(
                    destination: ComposersMapView(),
                    primaryIcon: "music.note",
                    secondaryIcon: "eyeglasses",
                    title: "Explore"
                )
            }
            .fixedSize(horizontal: true, vertical: true)
        }
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .bottomBar) {
                NavigationLink(destination: AcknowledgmentsView()) {
                    Label("Acknowledgments", systemImage: "info.circle")
                        .labelStyle(.titleAndIcon)
                }
                //.padding(5)
                .buttonStyle(.bordered)
                .background(.ultraThinMaterial)
                .cornerRadius(5)
                .font(.subheadline)
                .fontWeight(.light)
            }
#else
            NavigationLink(destination: AcknowledgmentsView()) {
                Label("Acknowledgments", systemImage: "info.circle")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
            .fontWeight(.light)
            .font(.subheadline)
#endif
        }
        .navigationTitle("Home")
#if os(iOS)
        .toolbarVisibility(.hidden)
#endif
        .shadow(radius: 0.5)
    }
    
}

struct WelcomeButton<Destination: View>: View {
    let destination: Destination
    let primaryIcon: String
    let secondaryIcon: String?
    let title: String
    
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

#Preview {
    ContentView()
}
