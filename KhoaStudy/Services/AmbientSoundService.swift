import Foundation
import AVFoundation

/// Dịch vụ phát âm thanh thật sự (Ambient Chill Sound Generator)
/// Hỗ trợ: Sóng Biển Đêm , Tiếng Mưa Rơi , Đêm Sao Chill 
/// Sử dụng AVAudioEngine tạo âm thanh mượt mà 100% offline, không bao giờ ngắt quãng
final class AmbientSoundService: ObservableObject {
    static let shared = AmbientSoundService()
    
    @Published var isPlaying: Bool = false
    @Published var isMuted: Bool = false
    @Published var selectedSoundIndex: Int = 0 // 0: Sóng Biển, 1: Mưa Đêm, 2: Đêm Sao
    
    private var audioEngine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    
    // Wave synthesis variables
    private var sampleRate: Double = 44100.0
    private var wavePhase: Double = 0.0
    private var wavePeriod: Double = 8.0 // 8s surf cycle
    private var noiseState: UInt32 = 123456789
    private var filterState: Double = 0.0
    private var rainState: Double = 0.0
    
    let soundNames = ["Sóng Biển Đêm", "Mưa Rơi Chill", "Đêm Sao Yên Tĩnh"]
    let soundIcons = ["water.waves", "cloud.rain.fill", "moon.stars.fill"]
    
    private init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Audio session configuration error: \(error)")
        }
    }
    
    func startSound(soundIndex: Int? = nil) {
        if let idx = soundIndex {
            selectedSoundIndex = idx
        }
        
        stopSound()
        
        let engine = AVAudioEngine()
        self.audioEngine = engine
        
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)!
        
        var localWavePhase = 0.0
        var localFilter = 0.0
        var localNoiseState: UInt32 = 987654321
        let activeType = selectedSoundIndex
        
        let node = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            
            for frame in 0..<Int(frameCount) {
                // Generate pink/brown noise
                localNoiseState = localNoiseState &* 1664525 &+ 1013904223
                let rawNoise = (Double(localNoiseState) / Double(UInt32.max)) * 2.0 - 1.0
                
                var sample: Float = 0.0
                
                if activeType == 0 {
                    // SÓNG BIỂN: Điều chế chu kỳ triều dâng và rút êm dịu (8 giây/chu kỳ)
                    localWavePhase += 1.0 / (44100.0 * 8.0)
                    if localWavePhase >= 1.0 { localWavePhase -= 1.0 }
                    
                    let waveEnvelope = 0.5 * (1.0 + sin(localWavePhase * 2.0 * .pi))
                    // Low-pass filter smoothing for soft wave foam
                    localFilter = localFilter * 0.94 + rawNoise * 0.06
                    sample = Float(localFilter * (0.15 + 0.35 * waveEnvelope))
                } else if activeType == 1 {
                    // MƯA ĐÊM: Hạt mưa nhẹ nhàng rả rích
                    localFilter = localFilter * 0.82 + rawNoise * 0.18
                    sample = Float(localFilter * 0.18)
                } else {
                    // ĐÊM SAO CHILL: Tiếng gió đêm và âm hưởng không gian sâu lắng
                    localWavePhase += 1.0 / (44100.0 * 12.0)
                    if localWavePhase >= 1.0 { localWavePhase -= 1.0 }
                    let breath = 0.5 * (1.0 + sin(localWavePhase * 2.0 * .pi))
                    localFilter = localFilter * 0.98 + rawNoise * 0.02
                    sample = Float(localFilter * (0.1 + 0.15 * breath))
                }
                
                for buffer in ablPointer {
                    let ptr = buffer.mData!.assumingMemoryBound(to: Float.self)
                    ptr[frame] = sample
                }
            }
            return noErr
        }
        
        self.sourceNode = node
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        
        engine.mainMixerNode.outputVolume = isMuted ? 0.0 : 0.8
        
        do {
            try engine.start()
            isPlaying = true
        } catch {
            print("Failed to start AVAudioEngine: \(error)")
        }
    }
    
    func stopSound() {
        audioEngine?.stop()
        if let node = sourceNode {
            audioEngine?.detach(node)
        }
        sourceNode = nil
        audioEngine = nil
        isPlaying = false
    }
    
    func togglePlayPause() {
        if isPlaying {
            stopSound()
        } else {
            startSound()
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
        audioEngine?.mainMixerNode.outputVolume = isMuted ? 0.0 : 0.8
    }
}
