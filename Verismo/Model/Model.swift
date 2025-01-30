//
//  Model.swift
//  Verismo
//
//  Created by Michał Lisicki on 21/01/2025.
//

import CoreLocation.CLLocation

struct Composer: Identifiable {
    var id = UUID()
    var composerID: composerID
    var firstname: String
    var surname: String
    var birthPlace: String
    var birthCoordinates: CLLocationCoordinate2D
    var lifespan: String
    var biography: String
}

struct Opera: Identifiable {
    var id = UUID()
    var operaID: operaID
    var composerID: composerID
    var title: String
    var coverImageName: String
    var premiereDate: Date
    var background: String
    var synopsis: String
    var musicInsights: String
}

struct Aria {
    var ariaID: ariaID
    var operaID: operaID
    var title: String
    var imageName: String
    var mainCharacter: String
    var background: String
    var recordingID: Int?
}

struct Recording: Identifiable, Decodable {
    var id: Int
    var ariaID: Int
    var conductor: String
    var singer: String
    var orchestra: String
    var year: String
    var subtitlesLanguage: String
    var audioPath: String
    var imageName: String
    var lyrics: [Lyric] = []
}

struct Lyric: Decodable {
    var start: TimeInterval
    var end: TimeInterval
    var text: String
    var singer: String
    var translation: String?
}
