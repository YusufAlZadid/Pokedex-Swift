import AVFoundation
import Foundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var audioPlayer: AVAudioPlayer?
    private let audioSession = AVAudioSession.sharedInstance()
    private var audioData: [URL: Data] = [:]
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session:", error.localizedDescription)
        }
    }
    
    func playPokemonCry(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to download cry audio:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    self?.audioPlayer?.stop()
                    self?.audioPlayer = try AVAudioPlayer(data: data)
                    self?.audioPlayer?.prepareToPlay()
                    self?.audioPlayer?.play()
                } catch {
                    print("Failed to play cry audio:", error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
    }
} 