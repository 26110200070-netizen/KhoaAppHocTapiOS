import Foundation
import AVFoundation

@MainActor
class FreeDictionaryService: ObservableObject {
    static let shared = FreeDictionaryService()
    
    @Published var isLoading: Bool = false
    @Published var currentResult: FreeDictionaryResponse? = nil
    @Published var vietnameseDefinitions: [String: String] = [:] // Key: definition, Value: Vietnamese translation
    @Published var errorMessage: String? = nil
    @Published var recentSearches: [String] = ["cause", "learn", "technology", "education", "future", "opportunity"]
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var memoryCache: [String: FreeDictionaryResponse] = [:]
    
    // MARK: - Native Speech Pronunciation
    func speak(text: String, languageCode: String = "en-US") {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: clean)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode) ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.46
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        
        speechSynthesizer.speak(utterance)
    }
    
    // MARK: - Search Word on Free Dictionary API
    func search(word: String) async {
        let clean = word.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !clean.isEmpty else { return }
        
        // Add to recents
        if !recentSearches.contains(clean) {
            recentSearches.insert(clean, at: 0)
            if recentSearches.count > 10 {
                recentSearches.removeLast()
            }
        }
        
        // Check in-memory cache
        if let cached = memoryCache[clean] {
            self.currentResult = cached
            self.errorMessage = nil
            self.translateDefinitionsToVietnamese(response: cached)
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        self.currentResult = nil
        
        guard let encoded = clean.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "https://freedictionaryapi.com/api/v1/entries/en/\(encoded)?translations=true") else {
            self.isLoading = false
            self.errorMessage = "Từ cần tra không hợp lệ"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        request.setValue("KhoaStudy-iOS/1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                self.isLoading = false
                self.errorMessage = "Không nhận được phản hồi từ máy chủ"
                return
            }
            
            if httpResponse.statusCode == 404 {
                self.isLoading = false
                self.errorMessage = "Không tìm thấy từ '\(clean)' trong từ điển Wiktionary"
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                self.isLoading = false
                self.errorMessage = "Lỗi máy chủ (mã \(httpResponse.statusCode))"
                return
            }
            
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(FreeDictionaryResponse.self, from: data)
            
            self.memoryCache[clean] = decoded
            self.currentResult = decoded
            self.isLoading = false
            
            // Translate definitions to Vietnamese
            self.translateDefinitionsToVietnamese(response: decoded)
            
        } catch {
            self.isLoading = false
            self.errorMessage = "Không thể kết nối đến Free Dictionary API: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Auto-Translate Definitions & Examples to Vietnamese
    private func translateDefinitionsToVietnamese(response: FreeDictionaryResponse) {
        guard let entries = response.entries else { return }
        
        for entry in entries {
            guard let senses = entry.senses else { continue }
            for sense in senses {
                // If sense already has a Wiktionary Vietnamese translation, store it directly
                if let viTrans = sense.vietnameseTranslation {
                    self.vietnameseDefinitions[sense.definition] = viTrans
                } else {
                    // Translate via fast background endpoint
                    let defText = sense.definition
                    Task {
                        if let translated = await self.fetchTranslation(text: defText, from: "en", to: "vi") {
                            self.vietnameseDefinitions[defText] = translated
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Fast Free Translation Engine (MyMemory)
    private func fetchTranslation(text: String, from: String, to: String) async -> String? {
        guard let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.mymemory.translated.net/get?q=\(encoded)&langpair=\(from)|\(to)") else {
            return nil
        }
        
        var req = URLRequest(url: url)
        req.timeoutInterval = 5.0
        
        do {
            let (data, res) = try await URLSession.shared.data(for: req)
            guard let http = res as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return nil }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let resData = json["responseData"] as? [String: Any],
               let trans = resData["translatedText"] as? String,
               !trans.isEmpty,
               !trans.contains("MYMEMORY WARNING:") {
                return trans
            }
        } catch {}
        return nil
    }
}
