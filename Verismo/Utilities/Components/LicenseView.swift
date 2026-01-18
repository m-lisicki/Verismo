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
