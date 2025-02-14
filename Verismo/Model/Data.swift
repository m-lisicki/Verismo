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
    case laBoheme = 0, turandot = 1, halka = 2, królRoger = 3, nabucco = 4
}

enum AriaID: Int {
    case nessumDorma = 0, nonPiangereLiu = 1, signoreAscolta = 2, inQuestaReggia = 3, szumiąJodły = 4, vaPensiero = 5, roxanaAria = 6
}

let composers = [
    Composer(
        composerID: .verdi,
        firstname: "Giuseppe",
        surname: "Verdi",
        birthPlace: "Busseto, Italy",
        birthCoordinates: CLLocationCoordinate2D(
            latitude: 45.7500,
            longitude: 10.1000
        ),
        lifespan: "1813-1901",
        biography:
        """
        Giuseppe Verdi is not only an outstanding composer, but also an icon of Italian culture. His works, such as Nabucco with its unforgettable chorus Va, pensiero, have become a symbol of the struggle for Italian freedom and unity. Verdi was able to combine deep emotion with virtuosic compositional technique in his music, creating masterpieces that still touch the hearts of listeners around the world today. His legacy is not only his operas, but also an inspiration for generations of artists and music lovers.
        """
    ),
    Composer(
        composerID: .puccini,
        firstname: "Giacomo",
        surname: "Puccini",
        birthPlace: "Lucca, Italy",
        birthCoordinates: CLLocationCoordinate2D(
            latitude: 43.7000,
            longitude: 12.5000
        ),
        lifespan: "1858-1924",
        biography:
        """
        Giacomo Puccini is an Italian composer, known for operas such as La Bohème, Tosca and Madama Butterfly. Born in Lucca, he came from a musical family and studied at the Milan Conservatory. His works are renowned for their emotional depth, memorable melodies and innovative orchestration, often exploring themes of love and sacrifice. Puccini is considered one of the most important composers of the late Romantic era, and his operas remain in the repertoire of opera houses around the world.
        """
    ),
    Composer(
        composerID: .moniuszko,
        firstname: "Stanisław",
        surname: "Moniuszko",
        birthPlace: "Urbany, Poland",
        birthCoordinates: CLLocationCoordinate2D(
            latitude: 53.1230,
            longitude: 20.6750
        ),
        lifespan: "1819-1872",
        biography:
        """
        Stanislaw Moniuszko, often referred to as the father of Polish opera, is famous for his works combining Polish folk music and themes. His best-known operas, Halka and Straszny Dwór, played a major role in shaping the national style in Polish music. Moniuszko's contribution to the opera repertoire is highly valued and his influence continues to inspire later composers.
        """
    ),
    Composer(
        composerID: .szymanowski,
        firstname: "Karol",
        surname: "Szymanowski",
        birthPlace: "Tymoszówka, Poland (now Ukraine)",
        birthCoordinates: CLLocationCoordinate2D(
            latitude: 49.8500,
            longitude: 32.4830
        ),
        lifespan: "1882-1937",
        biography: "Karol Szymanowski was a Polish composer and pianist, considered one of the most important Polish composers of the early 20th century. Szymanowski's work spans a variety of genres, including opera, symphonic music, chamber music and songs. His style evolved from late Romanticism to a more modern, impressionistic approach influenced by Polish folk music and Eastern European culture. His most important works include the opera King Roger and the symphony Stabat Mater. Szymanowski's contribution to music is valued for its innovation and emotional depth."
    )
]

let operas = [
    Opera(
        operaID: .laBoheme,
        composerID: .puccini,
        title: "La Bohème",
        coverImageName: "La Bohème - Spectacle",
        premiereDate: Date(
            timeIntervalSince1970: -2332468800
        ),
        background:
        """
        La Bohème is an opera in four acts by Giacomo Puccini, with a libretto by Luigi Illica and Giuseppe Giacosa. It is set in Paris in the 1830s and tells the story of a group of young bohemians living in the Latin Quarter, focusing on the love between the poet Rodolfo and the seamstress Mimì. The opera is famous for its poignant portrayal of youth, love and tragedy.
        """,
        synopsis:
        """
        The opera follows the lives of four bohemians, Rodolfo, Marcello, Colline and Schaunard, as they struggle with love, poverty and friendship. Rodolfo falls in love with Mimì, but their relationship is put to the test by Mimì's worsening illness. The story ends with Mimì's tragic death, highlighting the fragility of life and the enduring power of love.
        """,
        musicInsights:
        """
        The score of La Bohème is renowned for its lyrical beauty and emotional depth. Puccini's music captures the essence of bohemian life, from the vibrant camaraderie of friends to the tender intimacy of Rodolfo and Mimì's love. The opera contains unforgettable arias such as Che gelida manina and Sì, mi chiamano Mimì, which have become staples of the operatic repertoire. The music's ability to evoke both joy and sadness contributes to the enduring popularity of La Bohème.
        """),
    Opera(
        operaID: .turandot,
        composerID: .puccini,
        title: "Turandot",
        coverImageName: "Turandot - Spectacle",
        premiereDate: Date(
            timeIntervalSince1970: -1355875200
        ),
        background:
        """
        Turandot is an opera in three acts by Giacomo Puccini, completed by Franco Alfano after Puccini's death. It is set in ancient China and tells the story of a cold-hearted princess who asks impossible riddles of her suitors, executing those who fail to answer correctly. Puccini's last work is known for its grandeur and its famous aria Nessun Dorma.
        """,
        synopsis:
        """
        The story is set in ancient China, where Princess Turandot has decided that she will only marry the man who answers three riddles correctly. Prince Calaf accepts the challenge, risking his life for love. The opera explores themes of sacrifice, redemption and the power of love to overcome even the coldest of hearts.
        """,
        musicInsights:
        """
        The score of Turandot is rich in exoticism, reflecting the opera's Chinese setting. Puccini used pentatonic scales and traditional Chinese melodies to evoke the atmosphere. The dramatic contrast between the icy nature of Turandot and the warmth of Liù's aria is a highlight of the opera. The Nessun Dorma aria has become one of the most famous tenor arias in the repertoire, known for its triumphant climax and emotional depth.
        """),
    Opera(
        operaID: .halka,
        composerID: .moniuszko,
        title: "Halka",
        coverImageName: "Halka",
        premiereDate: Date(
            timeIntervalSince1970: -3849918369
        ),
        background:
        """
        Halka is a four-act opera by Stanislaw Moniuszko, considered one of the most important works of Polish opera. It tells the story of a highland girl, Halka, in love with the nobleman Janusz. The opera explores themes of love, betrayal and social class.
        """,
        synopsis:
        """
        Set in the Tatra Mountains, Halka is a tragic tale of unrequited love. Halka, a highland girl, is deeply in love with Janusz, a nobleman. However, Janusz is engaged to another woman, which leads to a series of tragic events culminating in Halka's despair and her ultimate sacrifice.
        """,
        musicInsights:
        """
        Moniuszko's score for Halka is rich in Polish folk melodies and rhythms, reflecting the setting and themes of the opera. The music beautifully captures the emotions of the characters, from the heartfelt arias of Halka to the exuberant dances of the highlanders. The opera is appreciated for its combination of nationalistic themes and universal human emotions.
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
        King Roger is an opera in three acts by Karol Szymanowski, set in Sicily in the 12th century. The opera explores the conflict between paganism and Christianity as King Roger struggles with his own beliefs and the influence of a mysterious shepherd.
        """,
        synopsis:
        """
        The story revolves around King Roger, who is torn between his Christian faith and the allure of pagan rituals introduced by a charismatic shepherd. The opera explores themes of spirituality, identity and the struggle between tradition and innovation.
        """,
        musicInsights:
        """
        Szymanowski's score for King Roger is a blend of late Romanticism and modernism, with rich orchestration and complex harmonies. The music reflects the inner turmoil of the characters and the clash of cultures, making it a powerful and thought-provoking work.
        """),
    Opera(
        operaID: .nabucco,
        composerID: .verdi,
        title: "Nabucco",
        coverImageName: "Nabucco - Background",
        premiereDate: Date(
            timeIntervalSince1970: -4033431124
        ),
        background:
        """
        Nabucco is an opera in four acts by Giuseppe Verdi, based on the biblical story of Nebuchadnezzar, King of Babylon. The opera is famous for its refrain Va, pensiero, which has become an anthem of Italian patriotism.
        """,
        synopsis:
        """
        The story tells the fate of the Israelites exiled from their homeland by King Nabucco. The opera explores themes of freedom, oppression and the power of faith. The chorus Va, pensiero is a poignant expression of the Israelites' longing for their lost homeland.
        """,
        musicInsights:
        """
        Verdi's score for Nabucco is dramatic and powerful, with memorable melodies and a strong emotional impact. The opera is known for its choral character and the way it captures the spirit of the Italian Risorgimento, the movement for Italian unification and independence.
        """)
]

let arias = [
    Aria(
        ariaID: .nessumDorma,
        operaID: .turandot,
        title: "Nessum Dorma",
        imageName: "Calaf",
        mainCharacter: "Prince Calaf",
        background: "Prince Calaf sings this iconic aria, expressing his unwavering determination to win the love of Princess Turandot, despite the challenges that await him. The aria is known for its triumphant climax and emotional depth, making it one of the most famous tenor arias in the repertoire.",
        recordingID: 0
    ),
    Aria(
        ariaID: .nonPiangereLiu,
        operaID: .turandot,
        title: "Non piangere, Liu",
        imageName: "Liu",
        mainCharacter: "Liu",
        background: "In this poignant aria, Liu, a devoted maid, expresses her deep love and compassion for Prince Calaf. She assures him not to cry, even in the face of despair, showing her selflessness and unwavering support. Liu's sincere emotions highlight the opera's themes of love and sacrifice.",
        recordingID: nil
    ),
    Aria(
        ariaID: .signoreAscolta,
        operaID: .turandot,
        title: "Signore, ascolta!",
        imageName: "Liu2",
        mainCharacter: "Liu",
        background: "Liù implores Prince Kalaf to abandon his dangerous pursuit of Princess Turandot, revealing her deep love for him. This aria highlights Liù's devotion and the emotional complexity of her character.",
        recordingID: nil
    ),
    Aria(
        ariaID: .inQuestaReggia,
        operaID: .turandot,
        title: "In questa reggia",
        imageName: "Princess Turandot",
        mainCharacter: "Princess Turandot",
        background: "Princess Turandot explains her motives and tells the tragic story of her ancestor, setting the stage for her icy demeanour. This aria provides an insight into Turandot's character and the reasons for her cold behaviour",
        recordingID: nil
    ),
    Aria(
        ariaID: .szumiąJodły,
        operaID: .halka,
        title: "Szumią Jodły",
        imageName: "Jontek",
        mainCharacter: "Jontek",
        background: "In this aria, Jontek expresses his love and longing for Halka, despite the social barriers that divide them. The aria is known for its beautiful melody and emotional depth.",
        recordingID: 1
    ),
    Aria(
        ariaID: .vaPensiero,
        operaID: .nabucco,
        title: "Va, pensiero",
        imageName: "Va Pensiero",
        mainCharacter: "Chorus of Hebrew Slaves",
        background: "In this aria, a chorus of Hebrew slaves expresses their longing for their homeland and freedom during their exile in Babylon. Va, pensiero is one of the most famous choruses in opera, known for its powerful melody and emotional resonance.",
        recordingID: 2
    ),
    Aria(
        ariaID: .roxanaAria,
        operaID: .królRoger,
        title: "Roxana's Song",
        imageName: "Król Roger 2",
        mainCharacter: "Queen Roxana",
        background: "This aria appears in Act II when Queen Roxana, Roger's wife, is enchanted by the Shepherd's presence. She sings a hypnotic, sensual melody, encouraging her husband to embrace the Shepherd's philosophy of ecstasy and freedom. The aria is characterised by lush orchestration, Eastern-inspired harmonies and a dreamy atmosphere, reflecting Roxana's growing infatuation and the Shepherd's seductive power.",
        recordingID: nil
    )
]
