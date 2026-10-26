import Foundation
import AVFoundation

@MainActor
class FreeDictionaryService: ObservableObject {
    static let shared = FreeDictionaryService()
    
    @Published var isLoading: Bool = false
    @Published var currentResult: FreeDictionaryResponse? = nil
    @Published var wordVietnameseMeaning: String? = nil // Main Vietnamese meaning of the word
    @Published var vietnameseDefinitions: [String: String] = [:] // Key: definition, Value: Vietnamese translation
    @Published var errorMessage: String? = nil
    @Published var recentSearches: [String] = ["technology", "nation", "cause", "education", "future", "opportunity"]
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var memoryCache: [String: FreeDictionaryResponse] = [:]
    private var meaningCache: [String: String] = [:]
    
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
            self.wordVietnameseMeaning = meaningCache[clean]
            self.errorMessage = nil
            self.translateDefinitionsToVietnamese(response: cached)
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        self.currentResult = nil
        self.wordVietnameseMeaning = nil
        
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
            
            // 1. Extract or translate the main word meaning
            extractOrTranslateMainWordMeaning(word: clean, response: decoded)
            
            // 2. Translate definitions to Vietnamese
            translateDefinitionsToVietnamese(response: decoded)
            
        } catch {
            self.isLoading = false
            self.errorMessage = "Không thể kết nối đến Free Dictionary API: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Extract or Translate Main Word Meaning
    private func extractOrTranslateMainWordMeaning(word: String, response: FreeDictionaryResponse) {
        // Try to find a direct translation in Wiktionary response
        if let entries = response.entries {
            for entry in entries {
                if let senses = entry.senses {
                    for sense in senses {
                        if let vi = sense.vietnameseTranslation, !vi.isEmpty {
                            self.wordVietnameseMeaning = cleanText(vi)
                            self.meaningCache[word] = self.wordVietnameseMeaning
                            return
                        }
                    }
                }
            }
        }
        
        // Translate the word itself
        Task {
            if let trans = await self.fetchTranslation(text: word) {
                let cleaned = self.cleanText(trans)
                self.wordVietnameseMeaning = cleaned
                self.meaningCache[word] = cleaned
            }
        }
    }
    
    // MARK: - Auto-Translate Definitions to Vietnamese
    private func translateDefinitionsToVietnamese(response: FreeDictionaryResponse) {
        guard let entries = response.entries else { return }
        
        Task {
            for entry in entries {
                guard let senses = entry.senses else { continue }
                // Limit to first 4 senses per entry to avoid overload and keep response snappy
                for sense in senses.prefix(4) {
                    if let viTrans = sense.vietnameseTranslation, !viTrans.isEmpty {
                        self.vietnameseDefinitions[sense.definition] = self.cleanText(viTrans)
                    } else {
                        // Clean definition text before translating
                        let defText = sense.definition
                        // Remove leading grammatical tags like "(countable)" or "(transitive)" for cleaner translation
                        let strippedDef = defText.replacingOccurrences(of: "^\\([^\\)]+\\)\\s*", with: "", options: .regularExpression)
                        if let translated = await self.fetchTranslation(text: strippedDef.isEmpty ? defText : strippedDef) {
                            self.vietnameseDefinitions[defText] = self.cleanText(translated)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Robust Translation Engine (Google GTX + MyMemory Fallback)
    private func fetchTranslation(text: String) async -> String? {
        let cleanInput = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanInput.isEmpty else { return nil }
        
        // Strategy 1: Google Translate GTX (fast, natural, no rate-limit issues on mobile)
        if let result = await fetchGoogleGTX(text: cleanInput) {
            return result
        }
        
        // Strategy 2: MyMemory API Fallback
        if let result = await fetchMyMemory(text: cleanInput) {
            return result
        }
        
        return nil
    }
    
    private func fetchGoogleGTX(text: String) async -> String? {
        guard let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=vi&dt=t&q=\(encoded)") else {
            return nil
        }
        
        var req = URLRequest(url: url)
        req.timeoutInterval = 4.0
        req.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X)", forHTTPHeaderField: "User-Agent")
        
        do {
            let (data, res) = try await URLSession.shared.data(for: req)
            guard let http = res as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return nil }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [Any],
               let parts = json.first as? [Any] {
                var full = ""
                for part in parts {
                    if let p = part as? [Any], let piece = p.first as? String {
                        full += piece
                    }
                }
                if !full.isEmpty {
                    return full
                }
            }
        } catch {}
        return nil
    }
    
    private func fetchMyMemory(text: String) async -> String? {
        guard let encoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.mymemory.translated.net/get?q=\(encoded)&langpair=en|vi") else {
            return nil
        }
        
        var req = URLRequest(url: url)
        req.timeoutInterval = 4.0
        
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
    
    // MARK: - String Sanitizer (Strip %20, HTML Entities, Corrupted Characters)
    func cleanText(_ raw: String) -> String {
        var text = raw
        
        // 1. Remove percent encoding repeatedly
        for _ in 0..<2 {
            if let unescaped = text.removingPercentEncoding {
                text = unescaped
            }
        }
        
        // 2. Explicitly remove any raw %20 or +
        text = text.replacingOccurrences(of: "%20", with: " ")
        text = text.replacingOccurrences(of: "%2C", with: ",", options: .caseInsensitive)
        text = text.replacingOccurrences(of: "%2E", with: ".", options: .caseInsensitive)
        text = text.replacingOccurrences(of: "%27", with: "'", options: .caseInsensitive)
        text = text.replacingOccurrences(of: "%22", with: "\"", options: .caseInsensitive)
        text = text.replacingOccurrences(of: "%3A", with: ":", options: .caseInsensitive)
        text = text.replacingOccurrences(of: "%3B", with: ";", options: .caseInsensitive)
        text = text.replacingOccurrences(of: "%28", with: "(", options: .caseInsensitive)
        text = text.replacingOccurrences(of: "%29", with: ")", options: .caseInsensitive)
        
        // 3. Decode HTML entities
        text = text.replacingOccurrences(of: "&quot;", with: "\"")
        text = text.replacingOccurrences(of: "&#39;", with: "'")
        text = text.replacingOccurrences(of: "&amp;", with: "&")
        text = text.replacingOccurrences(of: "&lt;", with: "<")
        text = text.replacingOccurrences(of: "&gt;", with: ">")
        
        // 4. Clean consecutive whitespace
        while text.contains("  ") {
            text = text.replacingOccurrences(of: "  ", with: " ")
        }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
