//
//  ViewModel.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import AVFAudio.AVAudioPlayer
@preconcurrency import Translation
import OSLog
let logger = Logger()

@MainActor
@Observable
final class ViewModel: NSObject {
    
    override init() {
        super.init()
        loadLibrettoDatabase()
#if os(iOS)
        configureAudioSession()
#endif
        self.volume = (UserDefaults.standard.object(forKey: "volume") as? Float) ?? 1.0 // Load initial volume value from UserDefaults
    }
    
    //MARK: - Translator
    
    var targetLanguage = Locale.Language(languageCode: "en", script: nil, region: "GB")
    var availableLanguages: [AvailableLanguage] = []
    var tempSneezeTranslation = false
    var translationPossible = false
    
    var subtitlesLanguageInterference = false
    
    func prepareSupportedLanguages() async {
        let supportedLanguages = await LanguageAvailability().supportedLanguages
        availableLanguages = supportedLanguages.lazy.map {
            AvailableLanguage(locale: $0)
        }
        .filter { language in
            return language.shortName != "en-US"
        }
        .sorted()
    }
    
    let maxLanguageCheckRetries = 5

    func checkLanguageAvailability() async {
        var retryCount = 0
        
        while retryCount < maxLanguageCheckRetries {
            let status = await LanguageAvailability().status(
                from: Locale.Language(languageCode: "en", region: "GB"),
                to: targetLanguage
            )
            
            switch status {
            case .installed:
                logger.info("Translation installed: translation is possible.")
                translationPossible = true
                return
            case .supported:
                logger.info("Translation is supported but not installed, retrying (\(retryCount))...")
                // Wait before rechecking availability. The model might be downloading in the background.
                try? await Task.sleep(for: .seconds(30))
                retryCount += 1
            default:
                logger.info("Translation not supported")
                translationPossible = false
                return
            }
        }
        if retryCount == maxLanguageCheckRetries {
            logger.warning("Reached maximum retries for awaiting translation availability.")
            translationPossible = false
        }
    }
    
    //MARK: - Interface Changes
    
    func resetWhileLeavingPlayback() {
        reset()
        audioPlayer = nil
    }
    
    //MARK: - User Defaults
    var volume: Float = 1.0 {
        didSet {
            UserDefaults.standard.set(volume, forKey: "volume")
            if let player = audioPlayer {
                player.volume = volume
            }
        }
    }
    
    //MARK: - Opera Database Operations
    var selectedRecording: Recording?
    var recordings: [Recording] = []
    
    var currentLyric: String = ""
    var currentSinger: String = ""
    var currentTranslation: String = ""
    
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
        guard let audioPath = selectedRecording?.audioPath else {
            logger.error("Audio path not found for the selected recording.")
            return
        }
        
        let mp3URL = Bundle.main.url(forResource: audioPath, withExtension: "mp3")
        let mpgaURL = Bundle.main.url(forResource: audioPath, withExtension: "mpga")
        
        guard let url = mp3URL ?? mpgaURL else {
            logger.error("Audio file not found for the selected recording.")
            return
        }
        
        if let audioPath = selectedRecording?.audioPath {
            logger.info("Playing audio for: \(audioPath)")
        }
        
        prepareAudioPlayer(with: url)
    }
    
    //MARK: - Audio Player
    var audioPlayer: AVAudioPlayer?
    
    var playbackProgress: Double = 0.0
    var totalTime: TimeInterval = 0.0
    
    func prepareAudioPlayer(with url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = volume //to ackowledge UserDefaults
            totalTime = audioPlayer?.duration ?? 0.0
            play()
        } catch {
            logger.error("Failed to prepare audio player: \(error)")
            isPlaying = false
            reset()
        }
    }
    
    //MARK: - Playback Controls
    var isPlaying: Bool = false
    
    // Toggle action
    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        if let player = audioPlayer {
            player.play()
        }
        
        isPlaying = true
        startTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }
    
    func reset() {
        audioPlayer?.stop()
        isPlaying = false
        
        audioPlayer?.currentTime = 0.0
        stopTimer()
        
        playbackProgress = 0.0
    }
    
    //MARK: - Timer (playback)
    
    let timerClockService = ClockService()
    
    func startTimer() {
        if let player = self.audioPlayer {
            self.playbackProgress = player.currentTime
        }
      
      timerClockService.start(interval: 0.1) {
        if let player = self.audioPlayer {
            self.playbackProgress = player.currentTime
            self.updateLyric(for: self.playbackProgress)
        }
      }
    }
    
    func stopTimer() {
      timerClockService.cancel()
    }
    
    //MARK: - Lyrics Updates
    
    func updateLyric(for time: TimeInterval) {
        guard let lyrics = selectedRecording?.lyrics else { return }
        
        if let lyric = lyrics.first(where: { $0.start <= time && $0.end > time }) {
            currentLyric = lyric.text
            currentSinger = lyric.singer
            currentTranslation = subtitlesLanguageInterference ? "" : (lyric.translation ?? "")
        } else if !currentLyric.isEmpty || !currentSinger.isEmpty || !currentTranslation.isEmpty {
            currentLyric = ""
            currentSinger = ""
            currentTranslation = ""
        }
    }
    
#if os(iOS)
    func configureAudioSession() {
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
