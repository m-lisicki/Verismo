//
//  Data.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/01/2025.
//

import CoreLocation.CLLocation

enum composerID: Int {
    case verdi = 0, puccini = 1, moniuszko = 2
}

enum operaID: Int {
    case turandot = 0
}

enum ariaID: Int {
    case nessumDorma = 0, nonPiangereLiu = 1, signoreAscolta = 2, inQuestaReggia = 3
}

let composers = [
    Composer(
        composerID: .verdi,
        firstname: "Giuseppe",
        surname: "Verdi",
        birthPlace: "Busseto, Italy",
        birthCoordinates: CLLocationCoordinate2D(
            latitude: 44.8500,
            longitude: 10.1000
        ),
        lifespan: "1813-1901",
        biography: "an Italian composer, is renowned for his operas such as La Traviata, Aida, and Rigoletto. Born in Le Roncole, he faced early hardships but eventually became a leading figure in Italian opera. Verdi's music is characterized by its dramatic intensity, memorable melodies, and complex characters, often reflecting the social and political issues of his time. His influence on the development of opera is profound, and he is celebrated as one of the greatest composers in the history of Western music."
    ),
    Composer(
        composerID: .puccini,
        firstname: "Giacomo",
        surname: "Puccini",
        birthPlace: "Lucca, Italy",
        birthCoordinates: CLLocationCoordinate2D(
            latitude: 43.8430,
            longitude: 10.5074
        ),
        lifespan: "1858-1924",
        biography: """
        an Italian composer known for his operas, which include La Bohème, Tosca, and Madama Butterfly. Born in Lucca, he came from a musical family and studied at the Milan Conservatory. Puccini's works are celebrated for their emotional depth, rich melodies, and innovative orchestration, often exploring themes of love and sacrifice. He is considered one of the most important composers of the late Romantic era, and his operas remain staples in the repertoire of opera houses worldwide.
        """
    ),
    Composer(
        composerID: .moniuszko,
        firstname: "Stanisław",
        surname: "Moniuszko",
        birthPlace: "Urbany, Poland",
        birthCoordinates: CLLocationCoordinate2D(
            latitude: 53.1230,
            longitude: 20.6780
        ),
        lifespan: "1819-1872",
        biography: "a Polish composer, often referred to as the father of Polish opera. He is best known for his operas, including Halka and Straszny Dwór, which incorporate Polish folk music and themes. Moniuszko's works played a significant role in the development of a national style in Polish music, and he is celebrated for his contributions to the operatic repertoire and his influence on later composers."
    )
]

let operas = [Opera(
    operaID: .turandot,
    composerID: .puccini,
    title: "Turandot",
    coverImageName: "Turandot - Spectacle",
    premiereDate: Date(
        timeIntervalSince1970: -1355875200
    ),
    background: """
        Turandot is an opera in three acts by Giacomo Puccini, completed by Franco Alfano after Puccini's death. It is set in ancient China and follows the story of a cold-hearted princess who sets impossible riddles to her suitors, executing those who fail to answer correctly. Puccini's final work is celebrated for its grandeur and the famous aria 'Nessun Dorma.'
        """,
    synopsis: """
        The story unfolds in ancient China, where Princess Turandot has decreed that she will marry only the man who can answer three riddles correctly. Prince Calaf takes up the challenge, risking his life for love. The opera explores themes of sacrifice, redemption, and the power of love to overcome even the coldest hearts.
        """,
    musicInsights: """
        Turandot's score is rich with exoticism, reflecting the opera's Chinese setting. Puccini employed pentatonic scales and traditional Chinese melodies to evoke the atmosphere. The dramatic contrast between Turandot's icy character and the warmth of Liù's arias is a highlight of the opera. The aria 'Nessun Dorma' has become one of the most famous tenor arias in the repertoire, celebrated for its triumphant climax and emotional depth.
        """)
]

let arias = [
    Aria(
        ariaID: .nessumDorma,
        operaID: .turandot,
        title: "Nessum Dorma",
        imageName: "Calaf",
        mainCharacter: "Prince Calaf",
        background: "Prince Calaf sings this iconic aria as he expresses his unwavering determination to win Princess Turandot's love, despite the challenges ahead."
    ),
    Aria(
        ariaID: .nonPiangereLiu,
        operaID: .turandot,
        title: "Non piangere, Liu",
        imageName: "Liu",
        mainCharacter: "Liu",
        background: "In this poignant aria, Liu, a devoted servant, expresses her deep love and compassion for Prince Calaf. She reassures him not to weep, even in the face of despair, showcasing her selflessness and unwavering support. Liu's heartfelt emotions highlight the themes of love and sacrifice within the opera.",
        recordingID: 0
    ),
    Aria(
        ariaID: .signoreAscolta,
        operaID: .turandot,
        title: "Signore, ascolta!",
        imageName: "Liu",
        mainCharacter: "Liu",
        background: "Liù pleads with Prince Calaf to abandon his dangerous pursuit of Princess Turandot, revealing her deep love for him."
    ),
    Aria(
        ariaID: .inQuestaReggia,
        operaID: .turandot,
        title: "In questa reggia",
        imageName: "Princess Turandot",
        mainCharacter: "Princess Turandot",
        background: "Princess Turandot explains her motives and recounts the tragic history of her ancestor, setting the stage for her icy demeanor."
    )
]
