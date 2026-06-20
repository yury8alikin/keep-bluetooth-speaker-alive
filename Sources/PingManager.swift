import Foundation
import AVFoundation

/// Manages the timer and programmatically generates/plays the inaudible ping.
class PingManager: ObservableObject {
    @Published var isActive: Bool = true {
        didSet {
            setupTimer()
        }
    }
    
    @Published var interval: Int = 30 {
        didSet {
            setupTimer()
        }
    }
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var wavData: Data?
    
    init() {
        // Load interval from UserDefaults, default to 30 if not set
        let savedInterval = UserDefaults.standard.integer(forKey: "pingInterval")
        self.interval = savedInterval == 0 ? 30 : savedInterval
        
        // Generate the 20Hz audio signal in memory
        self.wavData = PingManager.generate20HzWavData(duration: 0.5, sampleRate: 44100, frequency: 20.0, amplitude: 0.001)
        
        setupAudioPlayer()
        setupTimer()
    }
    
    private func setupAudioPlayer() {
        guard let wavData = wavData else { return }
        do {
            self.audioPlayer = try AVAudioPlayer(data: wavData)
            self.audioPlayer?.prepareToPlay()
            print("[PingManager] AVAudioPlayer initialized successfully.")
        } catch {
            print("[PingManager] Failed to initialize AVAudioPlayer: \(error)")
        }
    }
    
    private func setupTimer() {
        // Stop and invalidate the current timer
        timer?.invalidate()
        timer = nil
        
        guard isActive else {
            print("[PingManager] Pinging is disabled. Timer stopped.")
            return
        }
        
        print("[PingManager] Starting ping timer at interval: \(interval) seconds")
        
        // Run on the main RunLoop to ensure the timer fires reliably
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { [weak self] _ in
            self?.ping()
        }
    }
    
    private func ping() {
        guard isActive, let player = audioPlayer else { return }
        
        print("[PingManager] Pinging Bluetooth interface at \(Date())")
        if player.isPlaying {
            player.stop()
        }
        player.currentTime = 0
        player.play()
    }
    
    /// Cleans up resources for a leak-free exit.
    func cleanExit() {
        print("[PingManager] Performing clean exit. Stopping timers and releasing audio players.")
        timer?.invalidate()
        timer = nil
        
        audioPlayer?.stop()
        audioPlayer = nil
        wavData = nil
    }
    
    /// Generates a 16-bit mono PCM WAV file containing a sine wave at the specified frequency and amplitude.
    private static func generate20HzWavData(duration: Double, sampleRate: Int, frequency: Double, amplitude: Double) -> Data {
        let numSamples = Int(Double(sampleRate) * duration)
        let dataSize = numSamples * 2
        let fileSize = 36 + dataSize
        
        var header = Data()
        
        // RIFF header
        header.append("RIFF".data(using: .utf8)!)
        header.append(withUnsafeBytes(of: Int32(fileSize)) { Data($0) })
        header.append("WAVE".data(using: .utf8)!)
        
        // fmt chunk
        header.append("fmt ".data(using: .utf8)!)
        header.append(withUnsafeBytes(of: Int32(16)) { Data($0) }) // Chunk size
        header.append(withUnsafeBytes(of: Int16(1)) { Data($0) })  // Format: PCM (1)
        header.append(withUnsafeBytes(of: Int16(1)) { Data($0) })  // Channels: Mono (1)
        header.append(withUnsafeBytes(of: Int32(sampleRate)) { Data($0) })
        let byteRate = Int32(sampleRate * 1 * 2)
        header.append(withUnsafeBytes(of: byteRate) { Data($0) })
        header.append(withUnsafeBytes(of: Int16(2)) { Data($0) })  // Block align
        header.append(withUnsafeBytes(of: Int16(16)) { Data($0) }) // Bits per sample
        
        // data chunk
        header.append("data".data(using: .utf8)!)
        header.append(withUnsafeBytes(of: Int32(dataSize)) { Data($0) })
        
        var data = header
        data.reserveCapacity(44 + dataSize)
        
        // Sine wave generation
        for i in 0..<numSamples {
            let time = Double(i) / Double(sampleRate)
            let sineValue = sin(2.0 * .pi * frequency * time)
            let value = sineValue * amplitude
            
            // Convert to 16-bit signed integer PCM sample
            let sampleVal = Int16(max(-32768.0, min(32767.0, value * 32767.0)))
            data.append(withUnsafeBytes(of: sampleVal) { Data($0) })
        }
        
        return data
    }
}
