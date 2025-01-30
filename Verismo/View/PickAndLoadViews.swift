//
//  PickAndLoadView.swift
//  Verismo
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct PickOperaView: View {
    @EnvironmentObject var viewModel: ViewModel
    var chosenOpera: operaID?
    
    var filteredRecordings: [Recording] {
        if let chosenOpera = self.chosenOpera {
            return viewModel.recordings.filter { arias[$0.ariaID].operaID == chosenOpera}
        } else {
            return viewModel.recordings
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
#if os(macOS)
                .buttonStyle(.borderless)
                .listStyle(.plain)
#else
                .listStyle(.inset)
#endif
                .cornerRadius(10)
            }
            .navigationTitle("Editions List")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
#endif
            
#if os(macOS)
            .padding(50)
#else
            .padding(10)
#endif
        }
    }
}

#Preview {
    @Previewable @StateObject var model = ViewModel()
    PickOperaView()
        .environmentObject(model)
}

#if os(macOS)
struct OperaRow: View {
    let recording: Recording
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            Image(recording.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 85)
                .cornerRadius(8)
                .clipped()
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(arias[ariaID(rawValue: recording.ariaID)!.rawValue].title)
                    .font(.headline)
                    .fontDesign(.serif)
                
                HStack {
                    Text("Opera: \(operas[operaID(rawValue: arias[ariaID(rawValue: recording.ariaID)!.rawValue].operaID.rawValue)!.rawValue].title)")
                    Spacer()
                    Text("Year: \(recording.year)")
                }
                .foregroundStyle(.secondary)
                .font(.subheadline)
                
                HStack {
                    Text("Performer: \(recording.singer)")
                    Spacer()
                    Text("Translation: \(recording.subtitlesLanguage)")
                }
                .foregroundStyle(.secondary)
                .font(.subheadline)
            }
        }
    }
}
#else
struct OperaRow: View {
    let recording: Recording
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            Image(recording.imageName)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { size, axis in
                    size * 0.2
                }
                .cornerRadius(7)
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(arias[ariaID(rawValue: recording.ariaID)!.rawValue].title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .fontDesign(.serif)
                
                Group {
                    Text("Opera: \(operas[operaID(rawValue: arias[ariaID(rawValue: recording.ariaID)!.rawValue].operaID.rawValue)!.rawValue].title)")
                    Text("Year: \(recording.year)")
                    Text("Translation: \(recording.subtitlesLanguage)")
                    /*Text("Orchestra: \(opera.orchestra)")
                     .font(.subheadline)
                     .foregroundStyle(.secondary)*/
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
    }
}
#endif
