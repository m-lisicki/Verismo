//
//  OperaViewModel.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import AVFoundation
import Combine
import SwiftUI
@preconcurrency import Translation

final class ViewModel: NSObject, ObservableObject {
    
    override init() {
        super.init()
        loadLibrettoDatabase()
#if os(iOS)
        configureAudioSession()
#endif
    }
    
    //MARK: - Translator
    
    @Published var targetLanguage = Locale.Language(languageCode: "en", script: nil, region: "GB")
    var availableLanguages: [AvailableLanguage] = []
    var tempSneezeTranslation = false
    var translationPossible = false
    
    @MainActor
    func prepareSupportedLanguages() async {
            let supportedLanguages = await LanguageAvailability().supportedLanguages
            availableLanguages = supportedLanguages.map {
                AvailableLanguage(locale: $0)
            }
            .filter { language in
                let shortName = language.shortName()
                return shortName != "it" && shortName != "en-US"
            }
            .sorted()
    }
    
    @MainActor
    func checkLanguageAvailability() async {
        let status = await LanguageAvailability().status(from: Locale.Language(languageCode: "en", region: "GB"), to: targetLanguage)
        if status == .installed {
            print("possible")
            translationPossible = true
        } else if status == .supported {
            try? await Task.sleep(nanoseconds: 15 * 1_000_000_000) // 15 seconds
            //Checks to automaticaly switch to new translation if user downloads translation
            print("rechecking")
            await self.checkLanguageAvailability()
        }
    }
    
    //MARK: - Interface Changes
    
    func resetWhileLeavingPlayback() {
        reset()
        cancelLyricsUpdator()
    }

    //MARK: - User Defaults
    @AppStorage("volume") var volume: Double = 1.0 {
        didSet {
            if let player = audioPlayer {
                player.volume = Float(volume)
            } else if let stream = streamingPlayer {
                stream.volume = Float(volume)
            }
        }
    }
    
    //MARK: - Opera Database Operations
    @Published var chosenMode: Int?
    @Published var chosenComposer: Int?
    @Published var chosenOpera: String?
    @Published var selectedLibretto: LibrettoDatabase.Libretto?

    
    var operas: [LibrettoDatabase.Libretto] = []
    @Published var currentLyric: String = ""
    var currentSinger: String = ""
    var currentTranslation: String = "..."
    
    func loadLibrettoDatabase() {
        guard let url = Bundle.main.url(forResource: "librettoDatabase", withExtension: "json") else {
            print("Libretto database file not found.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let operaDatabase = try JSONDecoder().decode(LibrettoDatabase.self, from: data)
            operas = operaDatabase.operas
            print("Loading of database successful")
        } catch {
            print("Failed to load libretto database: \(error)")
        }
    }
    
    func selectOpera(_ opera: LibrettoDatabase.Libretto) {
        selectedLibretto = opera
    }
    
    //MARK: - Audio Player
    var audioPlayer: AVAudioPlayer?
    var streamingPlayer: AVPlayer?
    
    @Published var playbackProgress: Double = 0.0
    var totalTime: TimeInterval = 0.0
    
    func prepareToPlay(from url: URL) {
        if url.isFileURL {
            prepareAudioPlayer(with: url)
        } else {
            prepareStreamingPlayer(with: url)
        }
    }
    
    func prepareAudioPlayer(with url: URL) {
        do {
            streamingPlayer = nil
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = Float(volume) //to ackowledge UserDefaults
            totalTime = audioPlayer?.duration ?? 0.0
            setupLyricsUpdator()
            play()
        } catch {
            print("Failed to prepare audio player: \(error)")
            isPlaying = false
            reset()
        }
    }
    
    func prepareStreamingPlayer(with url: URL) {
        audioPlayer = nil
        /*https://developer.apple.com/documentation/avfoundation/controlling-the-transport-behavior-of-a-player*/
        streamingPlayer = AVPlayer(url: url)
        streamingPlayer?.volume = Float(volume)
        
        totalTime = 10000
        
        setupLyricsUpdator()
        play()
    }
    
    //MARK: - Playback Controls
    @Published var isPlaying: Bool = false
    
    // Toggle action
    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    // Play action
    func play() {
        if let player = audioPlayer {
            player.play()
        } else if let player = streamingPlayer {
            player.play()
        }
        
        isPlaying = true
        startTimer()
    }
    
    // Pause action
    func pause() {
        streamingPlayer?.pause()
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }
    
    // Stop action
    func reset() {
        audioPlayer?.stop()
        streamingPlayer?.pause()

        isPlaying = false
        
        audioPlayer?.currentTime = 0.0
        streamingPlayer?.seek(to: .zero)

        stopTimer()
        
        playbackProgress = 0.0
    }
    
    //MARK: - Timer (playback)
    
    private var timerCancellable: AnyCancellable?
    
     func startTimer() {
        timerCancellable = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if let player = self.audioPlayer {
                    self.playbackProgress = player.currentTime
                } else if let stream = self.streamingPlayer?.currentItem {
                    self.playbackProgress = stream.currentTime().seconds
                }
            }
    }
    
     func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    //MARK: - Lyrics Updates
    private var lyricsCancellable: AnyCancellable?
    private func setupLyricsUpdator() {
        lyricsCancellable = $playbackProgress
            .sink { [weak self] time in
                self?.updateLyric(for: time)
            }
    }
    
    private func cancelLyricsUpdator() {
        lyricsCancellable?.cancel()
        lyricsCancellable = nil
    }
    
    // Update the current lyric based on playback time
    private func updateLyric(for time: TimeInterval) {
        guard let lyrics = selectedLibretto?.lyrics else { return }
        
        if let lyric = lyrics.first(where: { $0.startTime <= time && $0.endTime > time }) {
            currentLyric = lyric.text
            currentSinger = lyric.singer
            currentTranslation = lyric.translation ?? ""
        } else if !currentLyric.isEmpty || !currentSinger.isEmpty || !currentTranslation.isEmpty {
            currentLyric = ""
            currentSinger = ""
            currentTranslation = ""
        }
    }
    
#if os(iOS)
    // Configures the audio session for iOS to handle audio playback
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
#endif
}

extension ViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        reset()
    }
}
