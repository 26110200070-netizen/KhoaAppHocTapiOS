import Foundation
import AVFoundation

@MainActor
class EnglishTranslationService: ObservableObject {
    static let shared = EnglishTranslationService()
    
    @Published var isTranslating: Bool = false
    @Published var lastResult: TranslationResult? = nil
    @Published var errorMessage: String? = nil
    
    private var debounceTimer: Timer? = nil
    
    // MARK: - Auto-Translate with Debounce
    func debounceTranslate(
        text: String,
        direction: TranslationDirection,
        delay: TimeInterval = 0.6,
        completion: @escaping (TranslationResult?) -> Void
    ) {
        debounceTimer?.invalidate()
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else {
            self.lastResult = nil
            self.isTranslating = false
            completion(nil)
            return
        }
        
        isTranslating = true
        debounceTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            Task { @MainActor in
                await self?.performTranslation(text: cleanText, direction: direction, completion: completion)
            }
        }
    }
    
    // MARK: - Perform Accurate Translation
    func performTranslation(
        text: String,
        direction: TranslationDirection,
        completion: @escaping (TranslationResult?) -> Void
    ) async {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else {
            self.lastResult = nil
            self.isTranslating = false
            completion(nil)
            return
        }
        
        self.isTranslating = true
        self.errorMessage = nil
        
        // 1. Try high-accuracy translation API
        if let apiResult = await fetchOnlineTranslation(text: cleanText, direction: direction) {
            let enriched = enrichWithGrammarNotes(sourceText: cleanText, translatedText: apiResult, direction: direction)
            self.lastResult = enriched
            self.isTranslating = false
            completion(enriched)
            return
        }
        
        // 2. Fallback to local dictionary / rule-based translation
        let fallback = localFallbackTranslate(text: cleanText, direction: direction)
        self.lastResult = fallback
        self.isTranslating = false
        completion(fallback)
    }
    
    // MARK: - Free High-Speed Translation API (MyMemory)
    private func fetchOnlineTranslation(text: String, direction: TranslationDirection) async -> String? {
        let sourceLang = direction.sourceLangCode
        let targetLang = direction.targetLangCode
        
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        let urlString = "https://api.mymemory.translated.net/get?q=\(encodedText)&langpair=\(sourceLang)|\(targetLang)"
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 6.0
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return nil
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let responseData = json["responseData"] as? [String: Any],
               let translated = responseData["translatedText"] as? String,
               !translated.isEmpty,
               !translated.contains("MYMEMORY WARNING:") {
                return translated.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        } catch {
            print("Online translation failed, switching to local fallback: \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: - Grammar & Key Phrases Extractor
    private func enrichWithGrammarNotes(
        sourceText: String,
        translatedText: String,
        direction: TranslationDirection
    ) -> TranslationResult {
        var notes: [String] = []
        var phrases: [String] = []
        
        let lowerSource = sourceText.lowercased()
        
        // Detect Tense and Structures (for EN source or VI source)
        if direction == .enToVi {
            if lowerSource.contains("will ") || lowerSource.contains("going to") {
                notes.append("• Thì tương lai (Future Tense): Diễn tả dự định hoặc hành động sắp diễn ra.")
            } else if lowerSource.contains("have ") || lowerSource.contains("has ") || lowerSource.contains("had ") {
                notes.append("• Thì hoàn thành (Perfect Tense): Nhấn mạnh kết quả hoặc trải nghiệm.")
            } else if lowerSource.contains("was ") || lowerSource.contains("were ") || lowerSource.contains("ed ") {
                notes.append("• Thì quá khứ (Past Tense): Hành động đã kết thúc trong quá khứ.")
            } else if lowerSource.contains("is ") || lowerSource.contains("are ") || lowerSource.contains("am ") {
                notes.append("• Thì hiện tại với to-be (Present Simple): Diễn đạt thực tế hoặc trạng thái.")
            }
            
            if lowerSource.contains("should") || lowerSource.contains("must") || lowerSource.contains("can") || lowerSource.contains("could") {
                notes.append("• Động từ khuyết thiếu (Modal Verbs): Bày tỏ khả năng, lời khuyên hoặc nghĩa vụ.")
            }
            
            // Extract key words
            let tokens = sourceText.components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count >= 4 }
            phrases = Array(Set(tokens)).prefix(4).map { $0.capitalized }
        } else {
            notes.append("• Bản dịch tự nhiên, chuẩn ngữ cảnh giao tiếp học thuật và đời sống.")
            let tokens = translatedText.components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count >= 4 }
            phrases = Array(Set(tokens)).prefix(4).map { $0.capitalized }
        }
        
        if notes.isEmpty {
            notes.append("• Cấu trúc câu chuẩn xác, ngữ nghĩa rõ ràng theo văn phong bản ngữ.")
        }
        
        return TranslationResult(
            translatedText: translatedText,
            keyPhrases: phrases,
            grammarNotes: notes.joined(separator: "\n")
        )
    }
    
    // MARK: - Local Offline Dictionary Fallback
    private func localFallbackTranslate(text: String, direction: TranslationDirection) -> TranslationResult {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let store = EnglishVocabularyStore.shared
        
        // Look up in our extensive vocabulary database
        if direction == .enToVi {
            if let matched = store.allWords.first(where: { $0.word.lowercased() == clean }) {
                return TranslationResult(
                    translatedText: matched.meaningVI,
                    keyPhrases: matched.collocations,
                    grammarNotes: "• Loại từ: \(matched.partOfSpeech) | Cấp độ: \(matched.level.rawValue) (\(matched.level.titleVI))\n• Phiên âm quốc tế: \(matched.phonetic)"
                )
            }
        } else {
            if let matched = store.allWords.first(where: { $0.meaningVI.lowercased().contains(clean) }) {
                return TranslationResult(
                    translatedText: matched.word,
                    keyPhrases: matched.collocations,
                    grammarNotes: "• Phiên âm: \(matched.phonetic) | Cấp độ: \(matched.level.rawValue)\n• Nghĩa chi tiết: \(matched.meaningVI)"
                )
            }
        }
        
        // Common phrases quick dictionary
        let quickDict: [String: (en: String, vi: String, note: String)] = [
            "hello": ("Hello", "Xin chào", "Lời chào phổ biến mọi tình huống"),
            "good morning": ("Good morning", "Chào buổi sáng", "Lời chào trang trọng buổi sáng"),
            "thank you": ("Thank you", "Cảm ơn bạn", "Bày tỏ lòng biết ơn"),
            "how are you": ("How are you?", "Bạn có khỏe không?", "Câu hỏi thăm sức khỏe thông dụng"),
            "i love you": ("I love you", "Tôi yêu bạn / Em yêu anh", "Bày tỏ tình cảm"),
            "where are you from": ("Where are you from?", "Bạn đến từ đâu?", "Hỏi về quê hương, quốc tịch"),
            "nice to meet you": ("Nice to meet you", "Rất vui được gặp bạn", "Chào hỏi trong lần đầu gặp"),
            "have a nice day": ("Have a nice day", "Chúc bạn một ngày tốt lành", "Lời chúc tạm biệt")
        ]
        
        if direction == .enToVi {
            for (key, val) in quickDict {
                if clean.contains(key) {
                    return TranslationResult(
                        translatedText: val.vi,
                        keyPhrases: [val.en],
                        grammarNotes: "• Ghi chú: \(val.note)"
                    )
                }
            }
            return TranslationResult(
                translatedText: "Bản dịch: " + text,
                keyPhrases: [],
                grammarNotes: "• Chế độ dịch offline cục bộ. Hãy kết nối Internet để nhận dịch AI ngữ cảnh chuyên sâu."
            )
        } else {
            for (_, val) in quickDict {
                if clean.contains(val.vi.lowercased()) {
                    return TranslationResult(
                        translatedText: val.en,
                        keyPhrases: [val.en],
                        grammarNotes: "• Ghi chú: \(val.note)"
                    )
                }
            }
            return TranslationResult(
                translatedText: text,
                keyPhrases: [],
                grammarNotes: "• Vui lòng kết nối mạng để dịch câu dài với Shimy AI."
            )
        }
    }
}
