//
//  PickOperaView.swift
//  Verismo
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct PickOperaView: View {
  @Environment(ViewModel.self) var viewModel

  let chosenOpera: OperaID?
  let chosenRecording: Recording?
  
  init(chosenOpera: OperaID? = nil, chosenRecording: Recording? = nil) {
    self.chosenOpera = chosenOpera
    self.chosenRecording = chosenRecording
  }
    
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
      ZStackBackgroundGradient {
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

private struct OperaRow: View {
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
                  TwoHSpaced {
                    Text(operas[OperaID(rawValue: arias[AriaID(rawValue: recording.ariaID)!.rawValue].operaID.rawValue)!.rawValue].title).labeled("Opera")
                  } trailing: {
                    Text(recording.year).labeled("Year")
                  }
                  TwoHSpaced {
                    Text(recording.singer).labeled("Performer")
                  } trailing: {
                    Text(recording.conductor).labeled("Conductor")
                  }
                  TwoHSpaced {
                    Text(recording.orchestra).labeled("Orchestra")
                  } trailing: {
                    EmptyView()
                  }
                  Spacer()
                  TwoHSpaced {
                    EmptyView()
                  } trailing: {
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
        .accessibilityLabel("Recording of aria: \(arias[AriaID(rawValue: recording.ariaID)!.rawValue].title) sung by: \(recording.singer), conducted by: \(recording.conductor), recorded in: \(recording.year), license: \(recording.license)")
        .sheet(isPresented: $showingLicenseDetail) {
            LicenseDetailView(license: recording.originalAttribution!, url: recording.url)
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

private struct LicenseButtonView: View {
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
  @Previewable @State var viewModel = ViewModel()
    NavigationStack {
        PickOperaView()
            .environment(viewModel)
    }
}
