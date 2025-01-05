//
//  OperaViewModel.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//
import AVFoundation
import SwiftUI
import Combine
import Translation


class ViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    override init() {
        super.init()
        loadLibrettoDatabase()
        #if os(iOS)
        configureAudioSession()
        #endif
        prepareSupportedLanguages()
    }
    
    //MARK: - Translator
    
    var availableLanguages: [AvailableLanguage] = []
    var translationPossible = false

    func prepareSupportedLanguages() {
        Task { @MainActor in
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
    }
    
    var configuration: TranslationSession.Configuration?
    
    let availability = LanguageAvailability()
    
    func checkLanguageAvailability() async {
        let status = await availability.status(from: Locale.Language(languageCode: "en", region: "GB"), to: targetLanguage)
        if status == .installed {
            translationPossible = true
        } else if status == .supported {
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                //Checks to automaticaly switch to new translation if user downloads translation
                Task {
                    await self.checkLanguageAvailability()
                }
            }*/
        }
    }
    
    //MARK: - Interface Changes
    @Published var showingWelcome: Bool = true
    @Published var showingOperaPicker: Bool = true

    func resetWhileLeavingPlayback() {
        reset()
        cancelLyricsUpdator()
    }
    
    func continueButtonClicked() {
        showingWelcome = false
    }
    
    //MARK: - User Defaults
    @Published var targetLanguage = Locale.Language(languageCode: "en", script: nil, region: "GB")
    
    @AppStorage("lyricsFontSize") var lyricsFontSize: Double = 48.0
    @AppStorage("volume") var volume: Double = 1.0 {
        didSet {
            if let player = audioPlayer {
                player.volume = Float(volume)
            }
        }
    }
    
    //MARK: - Opera Database Operations
    @Published var operas: [LibrettoDatabase.Libretto] = []
    @Published var selectedLibretto: LibrettoDatabase.Libretto?
    @Published var currentLyric: String = ""
    @Published var currentSinger: String = ""
    @Published var currentTranslation: String = "..."
    
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
        showingOperaPicker = false
    }
    
    //MARK: - Audio Player
    var audioPlayer: AVAudioPlayer?

    @Published var playbackProgress: Double = 0.0
    @Published var totalTime: TimeInterval = 0.0
    
    func prepareAudioPlayer(with url: URL) {
        do {
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        reset() // Reset playback states
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
        audioPlayer?.play()
        isPlaying = true
        startTimer()
    }
    
    // Pause action
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }
    
    // Stop action
    func reset() {
        audioPlayer?.stop()
        isPlaying = false

        audioPlayer?.currentTime = 0.0
        stopTimer()
        
        playbackProgress = 0.0
    }
    
    //MARK: - Timer (playback)

    private var timerCancellable: AnyCancellable?
    private func startTimer() {
        timerCancellable = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let player = self.audioPlayer else { return }
                self.playbackProgress = player.currentTime
            }
    }
    
    private func stopTimer() {
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
    /// Configures the audio session for iOS to handle audio playback
    private func configureAudioSession() {
        do {
            // Set the audio session category to playback
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            // Activate the audio session
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio session successfully configured for iOS.")
            
            // Optional: Handle interruptions (e.g., incoming calls)
            /*NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleInterruption),
                name: AVAudioSession.interruptionNotification,
                object: AVAudioSession.sharedInstance()
            )*/
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    /// Handles audio session interruptions
    /*@objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        if type == .began {
            // Interruption began, update UI or state as needed
            print("Audio session interruption began.")
            pause()
        } else if type == .ended {
            // Interruption ended, resume playback if needed
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    print("Audio session interruption ended. Resuming playback.")
                    play()
                }
            }
        }
    }*/
    
#endif

}
