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
        VStack {
            if /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/ {
                VStack(spacing: 70) {
                    Text("Welcome to Verismo.")
                        .fadingText()
                    HStack(spacing: 20) {
                        NavigationLink(destination: PickOperaView()){
                            VStack(spacing: 10) {
                                Image(systemName: "music.note")
                                    .font(.title2)
                                    .fontWeight(.light)
                                    .symbolRenderingMode(.hierarchical)
                                Text("Listen")
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
                        
                        NavigationLink(destination: ComposersMapView()){
                            VStack(spacing: 10) {
                                ZStack {
                                    Image(systemName: "music.note")
                                        .font(.title2)
                                        .fontWeight(.light)
                                        .hidden()
                                    Image(systemName: "eyeglasses")
                                        .font(.title2)
                                        .fontWeight(.light)
                                        .symbolRenderingMode(.hierarchical)
                                }
                                Text("Explore")
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
                    .fixedSize(horizontal: true, vertical: true)
                }
                .navigationTitle("Home")
#if os(iOS)
                .navigationBarHidden(true)
#endif
                .shadow(radius: 0.5)
            } else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var model = ViewModel()
    WelcomeView()
        .environmentObject(model)
}
