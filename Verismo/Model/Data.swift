//
//  Data.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/01/2025.
//

import CoreLocation.CLLocation

enum ComposerID: Int {
    case verdi = 0, puccini = 1, moniuszko = 2, szymanowski = 3
}

enum OperaID: Int {
    case turandot = 0, halka = 1, królRoger = 3, nabucco = 4
}

enum AriaID: Int {
    case nessumDorma = 0, nonPiangereLiu = 1, signoreAscolta = 2, inQuestaReggia = 3, szumiąJodły = 4
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
        biography:
        """
        Giuseppe Verdi is one of the most celebrated Italian composers, renowned for his operas such as "La Traviata," "Aida," and "Rigoletto." Born in Le Roncole, Verdi overcame early hardships to become a leading figure in Italian opera. His music is characterized by dramatic intensity, memorable melodies, and complex characters, often reflecting the social and political issues of his time. Verdi's influence on the development of opera is profound, and he is celebrated as one of the greatest composers in the history of Western music.
        """
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
        biography:
        """
        Giacomo Puccini is an Italian composer known for his operas, including "La Bohème," "Tosca," and "Madama Butterfly." Born in Lucca, he came from a musical family and studied at the Milan Conservatory. Puccini's works are celebrated for their emotional depth, rich melodies, and innovative orchestration, often exploring themes of love and sacrifice. He is considered one of the most important composers of the late Romantic era, and his operas remain staples in the repertoire of opera houses worldwide.
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
        biography:
        """
        Stanisław Moniuszko is a Polish composer often referred to as the father of Polish opera. He is best known for his operas, including "Halka" and "Straszny Dwór," which incorporate Polish folk music and themes. Moniuszko's works played a significant role in the development of a national style in Polish music, and he is celebrated for his contributions to the operatic repertoire and his influence on later composers.
        """
    ),
    Composer(
        composerID: .szymanowski,
        firstname: "Karol",
        surname: "Szymanowski",
        birthPlace: "Tymoszówka, Poland (now Ukraine)",
        birthCoordinates: CLLocationCoordinate2D(
            latitude: 49.8500,
            longitude: 32.4833
        ),
        lifespan: "1882-1937",
        biography: "Karol Szymanowski was a Polish composer and pianist, considered one of the most important Polish composers of the early 20th century. Born in Tymoszówka, Poland, Szymanowski's work spans various genres, including opera, symphonic music, chamber music, and songs. His style evolved from late Romanticism to a more modern, impressionistic approach, influenced by Polish folk music and Eastern European culture. Notable works include the opera 'King Roger' and the symphony 'Stabat Mater'. Szymanowski's contributions to music are celebrated for their innovation and emotional depth."
    )
]

let operas = [
    Opera(
        operaID: .turandot,
        composerID: .puccini,
        title: "Turandot",
        coverImageName: "Turandot - Spectacle",
        premiereDate: Date(
            timeIntervalSince1970: -1355875200
        ),
        background: """
        "Turandot" is an opera in three acts by Giacomo Puccini, completed by Franco Alfano after Puccini's death. Set in ancient China, it follows the story of a cold-hearted princess who sets impossible riddles to her suitors, executing those who fail to answer correctly. Puccini's final work is celebrated for its grandeur and the famous aria "Nessun Dorma."
        """,
        synopsis: """
        The story unfolds in ancient China, where Princess Turandot has decreed that she will marry only the man who can answer three riddles correctly. Prince Calaf takes up the challenge, risking his life for love. The opera explores themes of sacrifice, redemption, and the power of love to overcome even the coldest hearts.
        """,
        musicInsights: """
        "Turandot's" score is rich with exoticism, reflecting the opera's Chinese setting. Puccini employed pentatonic scales and traditional Chinese melodies to evoke the atmosphere. The dramatic contrast between Turandot's icy character and the warmth of Liù's arias is a highlight of the opera. The aria "Nessun Dorma" has become one of the most famous tenor arias in the repertoire, celebrated for its triumphant climax and emotional depth.
        """),
    Opera(
        operaID: .halka,
        composerID: .moniuszko,
        title: "Halka",
        coverImageName: "Halka",
        premiereDate: Date(
            timeIntervalSince1970: -3849918369
        ),
        background: """
        Halka is a four-act opera by Stanisław Moniuszko, considered one of the most important works in Polish opera. It tells the story of a highland girl, Halka, who is in love with a nobleman, Janusz. The opera explores themes of love, betrayal, and social class.
        """,
        synopsis:
        """
        Set in the Tatra Mountains, Halka is a tragic tale of unrequited love. Halka, a highland girl, is deeply in love with Janusz, a nobleman. However, Janusz is betrothed to another woman, leading to a series of tragic events that culminate in Halka's despair and ultimate sacrifice.
        """,
        musicInsights:
        """
        Moniuszko's score for Halka is rich in Polish folk melodies and rhythms, reflecting the opera's setting and themes. The music beautifully captures the emotions of the characters, from Halka's heartfelt arias to the lively dances of the highlanders. The opera is celebrated for its blend of nationalistic themes and universal human emotions.
        """),
    Opera(
        operaID: .królRoger,
        composerID: .szymanowski,
        title: "Król Roger",
        coverImageName: "Król Roger",
        premiereDate: Date(
            timeIntervalSince1970: -1373864884
        ),
        background:
        """
        "Król Roger" is an opera in three acts by Karol Szymanowski, set in 12th-century Sicily. The opera explores the conflict between paganism and Christianity, as King Roger grapples with his own beliefs and the influence of a mysterious shepherd.
        """,
        synopsis:
        """
        The story revolves around King Roger, who is torn between his Christian faith and the allure of pagan rituals introduced by a charismatic shepherd. The opera delves into themes of spirituality, identity, and the struggle between tradition and innovation.
        """,
        musicInsights:
        """
        Szymanowski's score for "Król Roger" is a blend of late Romanticism and modernism, with rich orchestration and complex harmonies. The music reflects the inner turmoil of the characters and the clash of cultures, making it a powerful and thought-provoking work.
        """),
    Opera(
        operaID: .nabucco,
        composerID: .verdi,
        title: "Nabucco",
        coverImageName: "Nabucco - Background",
        premiereDate: Date(
            timeIntervalSince1970: -4033431124
        ),
        background: """
        "Nabucco" is an opera in four acts by Giuseppe Verdi, based on the biblical story of Nebuchadnezzar, the King of Babylon. The opera is famous for its chorus "Va, pensiero," which has become an anthem for Italian patriotism.
        """,
        synopsis: """
        The story follows the plight of the Israelites as they are exiled from their homeland by King Nabucco. The opera explores themes of freedom, oppression, and the power of faith. The chorus "Va, pensiero" is a poignant expression of the Israelites' longing for their lost homeland.
        """,
        musicInsights: """
        Verdi's score for "Nabucco" is dramatic and powerful, with memorable melodies and a strong emotional impact. The opera is celebrated for its choral writing and the way it captures the spirit of the Italian Risorgimento, the movement for Italian unification and independence.
        """)
]

let arias = [
    Aria(
        ariaID: .nessumDorma,
        operaID: .turandot,
        title: "Nessum Dorma",
        imageName: "Calaf",
        mainCharacter: "Prince Calaf",
        background: "Prince Calaf sings this iconic aria as he expresses his unwavering determination to win Princess Turandot's love, despite the challenges ahead. The aria is known for its triumphant climax and emotional depth, making it one of the most famous tenor arias in the repertoire.",
        recordingID: 0
    ),
    Aria(
        ariaID: .nonPiangereLiu,
        operaID: .turandot,
        title: "Non piangere, Liu",
        imageName: "Liu",
        mainCharacter: "Liu",
        background: "In this poignant aria, Liu, a devoted servant, expresses her deep love and compassion for Prince Calaf. She reassures him not to weep, even in the face of despair, showcasing her selflessness and unwavering support. Liu's heartfelt emotions highlight the themes of love and sacrifice within the opera.",
        recordingID: nil
    ),
    Aria(
        ariaID: .signoreAscolta,
        operaID: .turandot,
        title: "Signore, ascolta!",
        imageName: "Liu",
        mainCharacter: "Liu",
        background: "Liù pleads with Prince Calaf to abandon his dangerous pursuit of Princess Turandot, revealing her deep love for him. This aria underscores Liù's devotion and the emotional complexity of her character.",
        recordingID: nil
    ),
    Aria(
        ariaID: .inQuestaReggia,
        operaID: .turandot,
        title: "In questa reggia",
        imageName: "Princess Turandot",
        mainCharacter: "Princess Turandot",
        background: "Princess Turandot explains her motives and recounts the tragic history of her ancestor, setting the stage for her icy demeanor. This aria provides insight into Turandot's character and the reasons behind her cold-hearted behavior.",
        recordingID: nil
    ),
    Aria(
        ariaID: .szumiąJodły,
        operaID: .halka,
        title: "Szumią Jodły",
        imageName: "Jontek",
        mainCharacter: "Jontek",
        background: "In this aria, Jontek expresses his love for Halka and his longing for her, despite the social barriers that separate them. The aria is known for its beautiful melody and emotional depth.",
        recordingID: 1
    )
]
