//
//  WelcomeView.swift
//  Verismo
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct WelcomeView: View {
  @Environment(ViewModel.self) var viewModel
  @State var acknowledgmentsIsPresented = false

    var body: some View {
      ZStackBackgroundGradient {
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
            .buttonStyle(.bordered)
            .background(.ultraThinMaterial)
            .cornerRadius(5)
            .font(.subheadline)
            .fontWeight(.light)
          }
#else
          Button {
            acknowledgmentsIsPresented = true
          } label: {
            Label("Acknowledgments", systemImage: "info.circle")
              .labelStyle(.titleAndIcon)
          }
          .buttonStyle(.bordered)
          .fontWeight(.light)
          .font(.subheadline)
#endif
        }
        .task {
          await viewModel.prepareSupportedLanguages()
        }
        .sheet(isPresented: $acknowledgmentsIsPresented) {
          NavigationStack {
            AcknowledgmentsView()
          }
        }
      }
        .navigationTitle("Home")
#if os(iOS)
        .toolbarVisibility(.hidden)
#endif
        .shadow(radius: 0.5)
    }
    
}

private struct AcknowledgmentsView: View {
  @Environment(\.dismiss) var dismiss

    var body: some View {
      ZStackBackgroundGradient {
            VStack {
                Text("Acknowledgments")
                    .fadingText()
                    .padding()
                
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Europeana")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .fontDesign(.serif)
                            Spacer()
                        }
                        Divider()
                        Text("I would like to acknowledge the Europeana initiative for collecting and providing access to Europe's cultural heritage. Their efforts have made it possible to include a rich collection of recordings and photographs in this app.")
                            .font(.body)
                            .padding(.vertical, 5)
                        HStack {
                            Text("Learn more:")
                                .font(.headline)
                            Link("visit europeana.eu", destination: URL(string: "https://www.europeana.eu")!)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .padding()
                    .background()
                    .cornerRadius(7)
                    .padding(.vertical, 5)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Photographs Credits")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .fontDesign(.serif)
                            Spacer()
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("Nabucco (Giuseppe Verdi) by Gerd Weiss - State Archives of Baden-Württemberg, Germany - CC BY.")
                                Link("Nabucco Image",
                                     destination: URL(string: "https://www.europeana.eu/pl/item/542/item_YUXTERCKB7HGKAR7LV2TA5L4DXOUNDCJ")!)
                            }
                            Divider()
                            Text("All uncredited photos are in the public domain.")
                                .fontWeight(.medium)
                        }
                        .font(.body)
                        .padding(.top, 5)
                    }
                    .accessibilityElement(children: .combine)
                    .padding()
                    .background()
                    .cornerRadius(7)
                    .padding(.vertical, 5)
            }
            .toolbar {
              ToolbarItem {
                Button("Close", systemImage: "xmark") { dismiss() }
              }
            }
            .padding()
            #if os(macOS)
            .padding(.horizontal)
            #endif
        }
    }
}

