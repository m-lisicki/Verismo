//
//  LicenseView.swift
//  Verismo
//
//  Created by Michał Lisicki on 13/02/2025.
//

import SwiftUI

struct LicenseDetailView: View {
    let license: String
    
    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 15) {
                Text("License Details")
                    .font(.headline)
                    .fontDesign(.serif)
                Text(license)
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
                        Text("We would like to acknowledge the Europeana initiative for collecting and providing access to Europe's cultural heritage. Their efforts have made it possible to include a rich collection of recordings and photographs in this app.")
                            .font(.body)
                            .padding(.vertical, 5)
                        HStack {
                            Text("Learn more about Europeana:")
                                .font(.headline)
                            Link("Visit europeana.eu", destination: URL(string: "https://www.europeana.eu")!)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .padding()
                    .background()
                    .cornerRadius(7)
                    .padding(.vertical, 5)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Photo Credits")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .fontDesign(.serif)
                            Spacer()
                        }
                        Divider()
                        VStack {
                            Text("All uncredited photos are in the public domain.")
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
        }
    }
}


#Preview {
    AcknowledgmentsView()
}
