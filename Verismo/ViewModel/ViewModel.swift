//
//  ViewModel.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import AVFAudio.AVAudioPlayer
import Combine
@preconcurrency import Translation
import OSLog
let logger = Logger()

final class ViewModel: NSObject, ObservableObject {
    
    override init() {
        super.init()
        loadLibrettoDatabase()
#if os(iOS)
        configureAudioSession()
#endif
        self.volume = UserDefaults.standard.double(forKey: "volume") // Load initial volume value from UserDefaults
    }
    
    //MARK: - Translator
    
    @Published var targetLanguage = Locale.Language(languageCode: "en", script: nil, region: "GB")
    @Published var availableLanguages: [AvailableLanguage] = []
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
            logger.info("Translation possible")
            translationPossible = true
        } else if status == .supported {
            try? await Task.sleep(nanoseconds: 15 * 1_000_000_000) // 15 seconds
            //Checks to automaticaly switch to new translation if user downloads translation
            logger.info("Rechecking avaibility of translation")
            await self.checkLanguageAvailability()
        }
    }
    
    //MARK: - Interface Changes
    
    func resetWhileLeavingPlayback() {
        reset()
        cancelLyricsUpdator()
        audioPlayer = nil
    }
    
    //MARK: - User Defaults
    @Published var volume: Double = 1.0 {
        didSet {
            UserDefaults.standard.set(volume, forKey: "volume")
            if let player = audioPlayer {
                player.volume = Float(volume)
            }
        }
    }
    
    //MARK: - Opera Database Operations
    @Published var selectedRecording: Recording?
    var recordings: [Recording] = []
    
    @Published var currentLyric: String = ""
    var currentSinger: String = ""
    var currentTranslation: String = "..."
    
    func loadLibrettoDatabase() {
        guard let url = Bundle.main.url(forResource: "recordingsDatabase", withExtension: "json") else {
            logger.warning("Libretto database file not found.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let recordingsDatabase = try JSONDecoder().decode([Recording].self, from: data)
            recordings = recordingsDatabase
            logger.info("Loading of database successful")
        } catch {
            logger.error("Failed to load libretto database: \(error)")
        }
    }
    
    func selectOperaAndPlay(_ opera: Recording) {
        selectedRecording = opera
        
        guard let url = Bundle.main.url(forResource: selectedRecording!.audioPath, withExtension: "mp3")  else {
            logger.error("Audio file not found")
            return
        }
        
        logger.info("Audio URL: \(self.selectedRecording!.audioPath)")
        prepareAudioPlayer(with: url)
    }
    
    //MARK: - Audio Player
    var audioPlayer: AVAudioPlayer?
    
    @Published var playbackProgress: Double = 0.0
    var totalTime: TimeInterval = 0.0
    
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
            logger.error("Failed to prepare audio player: \(error)")
            isPlaying = false
            reset()
        }
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
        }
        
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
    
    func startTimer() {
        if let player = self.audioPlayer {
            self.playbackProgress = player.currentTime
        }
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if let player = self.audioPlayer {
                    self.playbackProgress = player.currentTime
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
        guard let lyrics = selectedRecording?.lyrics else { return }
        
        if let lyric = lyrics.first(where: { $0.start <= time && $0.end > time }) {
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
            logger.error("Failed to configure audio session: \(error)")
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
