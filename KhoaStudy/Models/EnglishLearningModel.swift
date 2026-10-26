import Foundation
import AVFoundation

// MARK: - CEFR Level Enum
enum CEFRLevel: String, CaseIterable, Identifiable, Codable {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"
    case b2 = "B2"
    case c1 = "C1"
    case c2 = "C2"
    
    var id: String { self.rawValue }
    
    var titleEN: String {
        switch self {
        case .a1: return "Beginner"
        case .a2: return "Elementary"
        case .b1: return "Intermediate"
        case .b2: return "Upper-Intermediate"
        case .c1: return "Advanced"
        case .c2: return "Proficiency"
        }
    }
    
    var titleVI: String {
        switch self {
        case .a1: return "Sơ cấp"
        case .a2: return "Sơ cấp cao"
        case .b1: return "Trung cấp"
        case .b2: return "Trung cấp cao"
        case .c1: return "Cao cấp"
        case .c2: return "Thành thạo"
        }
    }
    
    var description: String {
        switch self {
        case .a1: return "Chào hỏi, số đếm, gia đình, đồ ăn, trường học"
        case .a2: return "Mua sắm, du lịch, sức khỏe, công việc hằng ngày"
        case .b1: return "Giao tiếp đời sống, trải nghiệm, cảm xúc, công việc"
        case .b2: return "Thảo luận, học thuật cơ bản, tin tức, xã hội"
        case .c1: return "Từ vựng chuyên sâu, diễn đạt ý tưởng phức tạp"
        case .c2: return "Từ vựng tinh tế, thành ngữ, sắc thái ngôn ngữ"
        }
    }
    
    var badgeColorHex: String {
        switch self {
        case .a1: return "#059669"
        case .a2: return "#0284C7"
        case .b1: return "#2563EB"
        case .b2: return "#7C3AED"
        case .c1: return "#EA580C"
        case .c2: return "#DC2626"
        }
    }
}

// MARK: - Vocabulary Category Enum
enum VocabCategory: String, CaseIterable, Identifiable, Codable {
    case all = "Tất Cả Chủ Đề"
    case family = "Gia đình"
    case education = "Giáo dục"
    case dailyLife = "Đời sống"
    case shopping = "Shopping & Mua sắm"
    case needs = "Nhu cầu cá nhân"
    case emotions = "Cảm xúc & Tâm lý"
    case devices = "Thiết bị & Đồ dùng"
    case technology = "Công nghệ & AI"
    case transport = "Phương tiện giao thông"
    case communication = "Giao tiếp xã hội"
    case food = "Thực phẩm"
    case dining = "Ăn uống & Nhà hàng"
    case health = "Sức khỏe & Thể thao"
    case travel = "Du lịch & Văn hóa"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .education: return "graduationcap.fill"
        case .dailyLife: return "sun.max.fill"
        case .shopping: return "cart.fill"
        case .needs: return "heart.text.square.fill"
        case .emotions: return "sparkles"
        case .devices: return "desktopcomputer"
        case .technology: return "cpu"
        case .transport: return "car.fill"
        case .communication: return "bubble.left.and.bubble.right.fill"
        case .food: return "leaf.fill"
        case .dining: return "fork.knife"
        case .health: return "cross.case.fill"
        case .travel: return "airplane"
        }
    }
}

// MARK: - Vocabulary Word Model
struct EnglishWord: Identifiable, Codable, Hashable {
    var id: String { word.lowercased() }
    let word: String
    let phonetic: String
    let partOfSpeech: String // n. (noun), v. (verb), adj., adv., idiom, phrase
    let meaningVI: String
    let category: VocabCategory
    let level: CEFRLevel
    let collocations: [String]
    let examples: [WordExample]
}

struct WordExample: Codable, Hashable {
    let sentenceEN: String
    let sentenceVI: String
}

// MARK: - Translation Model
enum TranslationDirection: String, CaseIterable, Identifiable {
    case enToVi = "Anh - Việt"
    case viToEn = "Việt - Anh"
    
    var id: String { self.rawValue }
    
    var sourceLangCode: String {
        switch self {
        case .enToVi: return "en"
        case .viToEn: return "vi"
        }
    }
    
    var targetLangCode: String {
        switch self {
        case .enToVi: return "vi"
        case .viToEn: return "en"
        }
    }
    
    var sourceTitle: String {
        switch self {
        case .enToVi: return "Tiếng Anh"
        case .viToEn: return "Tiếng Việt"
        }
    }
    
    var targetTitle: String {
        switch self {
        case .enToVi: return "Tiếng Việt"
        case .viToEn: return "Tiếng Anh"
        }
    }
}

struct TranslationResult: Codable {
    let translatedText: String
    let keyPhrases: [String]
    let grammarNotes: String
}
