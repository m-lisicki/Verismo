//
//  PickAndLoadView.swift
//  Verismo
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct PickOperaView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var chosenOpera: OperaID?
    var chosenRecording: Recording?
    
    var filteredRecordings: [Recording] {
        if let chosenOpera = self.chosenOpera {
            viewModel.recordings.filter { arias[$0.ariaID].operaID == chosenOpera}
        } else if let chosenRecording = self.chosenRecording {
            [chosenRecording]
        } else {
            viewModel.recordings
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack {
                List(filteredRecordings) { recording in
                    NavigationLink(destination: PlaybackView(recording: recording)) {
                        OperaRow(recording: recording)
                            .padding(.vertical, 8)
                    }
                }
                .scrollContentBackground(.hidden)
#if os(macOS)
                .background(.thickMaterial)
#else
                .background(.thinMaterial)
#endif
                .cornerRadius(8)
            }
            .navigationTitle("Editions List")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
#endif
            
#if os(macOS)
            .padding(30)
#else
            .padding(10)
#endif
        }
    }
}

struct OperaRow: View {
    let recording: Recording
    @State var showingLicenseDetail = false
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            Image(decorative: recording.imageName)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, axis in
#if os(macOS)
                    size * 0.1
#else
                    size * 0.2
#endif
                }
                .scaledToFit()
                .cornerRadius(3)
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(arias[AriaID(rawValue: recording.ariaID)!.rawValue].title)
                    .font(.headline)
                    .fontDesign(.serif)
#if os(macOS)
                VStack {
                    HStack {
                        Text("Opera: \(operas[OperaID(rawValue: arias[AriaID(rawValue: recording.ariaID)!.rawValue].operaID.rawValue)!.rawValue].title)")
                        Spacer()
                        Text("Year: \(recording.year)")
                    }
                    HStack {
                        Text("Performer: \(recording.singer)")
                        Spacer()
                        Text("Conductor: \(recording.conductor)")
                    }
                    HStack {
                        Text("Orchestra: \(recording.orchestra)")
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        LicenseButtonView(recording: recording, showingLicenseDetail: $showingLicenseDetail)
                    }
                }
                .foregroundStyle(.secondary)
                .font(.caption)
#else
                Group {
                    Text("Opera: \(operas[OperaID(rawValue: arias[AriaID(rawValue: recording.ariaID)!.rawValue].operaID.rawValue)!.rawValue].title)")
                        .font(.subheadline)
                    Text("Year: \(recording.year)")
                    Text("Conductor: \(recording.conductor)")
                    Text("Singer: \(recording.singer)")
                    Text("Orchestra: \(recording.orchestra)")
                        .padding(.bottom, 10)
                    LicenseButtonView(recording: recording, showingLicenseDetail: $showingLicenseDetail)
                }
                .foregroundStyle(.secondary)
                .font(.caption)
                
#endif
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("Recording of aria: \(arias[AriaID(rawValue: recording.ariaID)!.rawValue].title) sung by: \(recording.singer), recorded in: \(recording.year), translation source libretto language: \(recording.subtitlesLanguage)")
        .sheet(isPresented: $showingLicenseDetail) {
            LicenseDetailView(license: recording.originalAttribution!)
                .toolbar {
#if os(macOS)
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showingLicenseDetail = false
                        }
                    }
#endif
                }
                .presentationBackground(.thinMaterial)
                .presentationDetents([.medium])
        }
    }
}

struct LicenseButtonView: View {
    let recording: Recording
    @Binding var showingLicenseDetail: Bool
    
    var body: some View {
        HStack {
            Text("License: \(recording.license)")
            if recording.originalAttribution != nil {
                Button(action: { showingLicenseDetail = true }) {
                    Image(systemName: "info.circle")
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Show license details")
            }
        }
    }
}


#Preview {
    @Previewable @StateObject var model = ViewModel()
    NavigationStack {
        PickOperaView()
            .environmentObject(model)
    }
}
