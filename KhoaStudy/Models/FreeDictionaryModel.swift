import Foundation

// MARK: - Free Dictionary API Response Models
// Documentation: https://freedictionaryapi.com/api/v1
// Data source: English Wiktionary (8,500,000+ words)

struct FreeDictionaryResponse: Codable, Identifiable {
    var id: String { word }
    let word: String
    let entries: [DictionaryEntry]?
    let source: DictionarySource?
}

struct DictionaryEntry: Codable, Identifiable {
    var id: String {
        let pos = partOfSpeech ?? "unknown"
        let def = senses?.first?.definition ?? UUID().uuidString
        return "\(pos)-\(def)"
    }
    
    let language: DictionaryLanguage?
    let partOfSpeech: String?
    let pronunciations: [DictionaryPronunciation]?
    let forms: [DictionaryForm]?
    let senses: [DictionarySense]?
    let synonyms: [String]?
    let antonyms: [String]?
    
    // Helper: Vietnamese name for Part of Speech
    var partOfSpeechVI: String {
        guard let pos = partOfSpeech?.lowercased() else { return "Từ loại" }
        switch pos {
        case "noun": return "Danh từ"
        case "verb": return "Động từ"
        case "adjective": return "Tính từ"
        case "adverb": return "Phó từ / Trạng từ"
        case "pronoun": return "Đại từ"
        case "preposition": return "Giới từ"
        case "conjunction": return "Liên từ"
        case "interjection": return "Thán từ"
        case "idiom": return "Thành ngữ"
        case "phrase": return "Cụm từ"
        default: return pos.capitalized
        }
    }
    
    var posBadgeColorHex: String {
        guard let pos = partOfSpeech?.lowercased() else { return "#6B7280" }
        switch pos {
        case "noun": return "#2563EB"       // Blue
        case "verb": return "#059669"       // Emerald green
        case "adjective": return "#D97706"  // Amber
        case "adverb": return "#7C3AED"     // Purple
        case "conjunction": return "#DC2626"// Red
        default: return "#4B5563"
        }
    }
}

struct DictionaryLanguage: Codable {
    let code: String?
    let name: String?
}

struct DictionaryPronunciation: Codable, Identifiable {
    var id: String { "\(type ?? "")-\(text ?? "")-\(tags?.joined() ?? "")" }
    let type: String? // e.g. "ipa"
    let text: String? // e.g. "/kɔːz/"
    let tags: [String]? // e.g. ["General American", "Received Pronunciation"]
}

struct DictionaryForm: Codable, Identifiable {
    var id: String { "\(word ?? "")-\(tags?.joined() ?? "")" }
    let word: String?
    let tags: [String]? // e.g. ["plural", "present", "past"]
}

struct DictionarySense: Codable, Identifiable {
    var id: String { definition }
    let definition: String
    let tags: [String]?
    let examples: [String]?
    let synonyms: [String]?
    let antonyms: [String]?
    let translations: [SenseTranslation]?
    
    // Extracted Vietnamese translation if available in Wiktionary
    var vietnameseTranslation: String? {
        if let trans = translations {
            for t in trans {
                if t.language?.code == "vi" || (t.language?.name?.lowercased().contains("viet") ?? false) {
                    if let w = t.word, !w.isEmpty {
                        return w
                    }
                }
            }
        }
        return nil
    }
}

struct SenseTranslation: Codable {
    let language: DictionaryLanguage?
    let word: String?
}

struct DictionarySource: Codable {
    let url: String?
    let license: DictionaryLicense?
}

struct DictionaryLicense: Codable {
    let name: String?
    let url: String?
}
