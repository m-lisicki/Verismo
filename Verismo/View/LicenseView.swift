//
//  LicenseView.swift
//  Verismo
//
//  Created by Michał Lisicki on 13/02/2025.
//

import SwiftUI

struct LicenseDetailView: View {
    let license: String
    let url: String
    
    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 15) {
                Text("License Details")
                    .font(.headline)
                    .fontDesign(.serif)
                Text(license)
                Link("Media URL", destination: URL(string: url)!)
            }
            .padding()
        }
    }
}

struct AcknowledgmentsView: View {
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                Text("Acknowledgments")
                    .fadingText()
                    .padding()
                
                ScrollView {
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
            }
            .padding()
            #if os(macOS)
            .padding(.horizontal)
            #endif
        }
    }
}


#Preview {
    AcknowledgmentsView()
}
