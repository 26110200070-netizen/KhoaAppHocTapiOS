import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable, Codable {
    case vietnamese = "Tiếng Việt"
    case english = "English"
    
    var code: String {
        switch self {
        case .vietnamese: return "vi"
        case .english: return "en"
        }
    }
    
    var flag: String {
        switch self {
        case .vietnamese: return "🇻🇳"
        case .english: return "🇺🇸"
        }
    }
}

struct UserProfile: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var username: String
    var email: String
    var grade: Int
    var avatarName: String
}

class AppState: ObservableObject {
    // Flow control: Intro -> Login -> Main App
    @Published var hasSeenIntro: Bool = false
    @Published var isLoggedIn: Bool = false // Must login first!
    
    @Published var currentUser: UserProfile
    @Published var savedAccounts: [UserProfile] = []
    
    @Published var currentLanguage: AppLanguage = .vietnamese
    @Published var selectedGrade: SchoolGrade = .g12
    @Published var selectedLevel: SchoolLevel = .thpt
    
    // Focus & Study tracking
    @Published var totalStudyMinutes: Int = 135
    @Published var focusSessionCount: Int = 4
    @Published var isFocusLockActive: Bool = false
    
    // AI Provider Configuration (Groq Cloud & Google Gemini)
    @Published var selectedProvider: AIProvider = .groq
    @Published var groqApiKey: String = ""
    @Published var selectedGroqModel: String = "llama-3.3-70b-versatile"
    @Published var geminiApiKey: String = ""
    @Published var appAuthToken: String = ""
    @Published var serverUrl: String = "http://192.168.2.16:8000/v1"
    @Published var isAIConnected: Bool = false
    @Published var userRole: String = "student"
    @Published var remainingDailyQuota: Int = 9999
    
    // Backward compatibility alias
    var isGeminiConnected: Bool {
        get { isAIConnected }
        set { isAIConnected = newValue }
    }
    
    var hasActiveAI: Bool {
        switch selectedProvider {
        case .groq:
            return !groqApiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .gemini:
            return !geminiApiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    init() {
        let defaultUser = UserProfile(
            username: "Anh Khoa Dev",
            email: "khoadev@study.edu.vn",
            grade: 12,
            avatarName: "person.crop.circle.fill"
        )
        self.currentUser = defaultUser
        self.savedAccounts = [
            defaultUser,
            UserProfile(username: "Học Sinh THPT", email: "student.thpt@study.vn", grade: 12, avatarName: "graduationcap.circle.fill"),
            UserProfile(username: "Học Sinh THCS", email: "student.thcs@study.vn", grade: 9, avatarName: "backpack.circle.fill")
        ]
        
        // Restore saved provider
        if let savedProviderStr = UserDefaults.standard.string(forKey: "shimy_ai_provider"),
           let savedProv = AIProvider(rawValue: savedProviderStr) {
            self.selectedProvider = savedProv
        }
        
        // Restore Groq configuration
        if let savedGroqKey = UserDefaults.standard.string(forKey: "shimy_groq_key"), !savedGroqKey.isEmpty {
            self.groqApiKey = savedGroqKey
        }
        if let savedGroqModel = UserDefaults.standard.string(forKey: "shimy_groq_model"), !savedGroqModel.isEmpty {
            self.selectedGroqModel = savedGroqModel
        }
        
        // Restore saved token & server url if available
        if let savedToken = UserDefaults.standard.string(forKey: "shimy_app_token") {
            self.appAuthToken = savedToken
        }
        if let savedUrl = UserDefaults.standard.string(forKey: "shimy_server_url"), !savedUrl.isEmpty {
            self.serverUrl = savedUrl
        }
        if let savedGeminiKey = UserDefaults.standard.string(forKey: "shimy_gemini_key"), !savedGeminiKey.isEmpty {
            self.geminiApiKey = savedGeminiKey
        }
        
        let hasValidAI = (self.selectedProvider == .groq && !self.groqApiKey.isEmpty) ||
                         (self.selectedProvider == .gemini && !self.geminiApiKey.isEmpty) ||
                         !self.groqApiKey.isEmpty ||
                         !self.geminiApiKey.isEmpty
        self.isAIConnected = hasValidAI
        
        let previouslyLoggedIn = UserDefaults.standard.bool(forKey: "user_logged_in")
        self.isLoggedIn = previouslyLoggedIn && hasValidAI
        self.hasSeenIntro = UserDefaults.standard.bool(forKey: "has_seen_intro")
    }
    
    func switchAccount(to user: UserProfile) {
        self.currentUser = user
        if let g = SchoolGrade(rawValue: user.grade) {
            self.selectedGrade = g
            self.selectedLevel = g.level
        }
    }
    
    func logout() {
        self.isLoggedIn = false
        self.groqApiKey = ""
        self.geminiApiKey = ""
        self.isAIConnected = false
        UserDefaults.standard.set(false, forKey: "user_logged_in")
        UserDefaults.standard.removeObject(forKey: "shimy_groq_key")
        UserDefaults.standard.removeObject(forKey: "shimy_gemini_key")
        UserDefaults.standard.removeObject(forKey: "shimy_app_token")
    }
    
    func login(
        username: String,
        token: String? = nil,
        role: String = "student",
        remainingQuota: Int = 9999,
        provider: AIProvider = .groq,
        geminiKey: String? = nil,
        groqKey: String? = nil,
        groqModel: String? = nil
    ) {
        self.currentUser.username = username
        self.selectedProvider = provider
        UserDefaults.standard.set(provider.rawValue, forKey: "shimy_ai_provider")
        
        if let t = token, !t.isEmpty {
            self.appAuthToken = t
            UserDefaults.standard.set(t, forKey: "shimy_app_token")
        }
        if let gk = groqKey, !gk.isEmpty {
            self.groqApiKey = gk
            UserDefaults.standard.set(gk, forKey: "shimy_groq_key")
        }
        if let gm = groqModel, !gm.isEmpty {
            self.selectedGroqModel = gm
            UserDefaults.standard.set(gm, forKey: "shimy_groq_model")
        }
        if let k = geminiKey, !k.isEmpty {
            self.geminiApiKey = k
            UserDefaults.standard.set(k, forKey: "shimy_gemini_key")
        }
        self.isAIConnected = (!self.groqApiKey.isEmpty && self.selectedProvider == .groq) ||
                             (!self.geminiApiKey.isEmpty && self.selectedProvider == .gemini) ||
                             !self.groqApiKey.isEmpty || !self.geminiApiKey.isEmpty
        self.userRole = role
        self.remainingDailyQuota = remainingQuota
        self.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "user_logged_in")
        UserDefaults.standard.set(self.serverUrl, forKey: "shimy_server_url")
    }
    
    func completeIntro() {
        self.hasSeenIntro = true
        UserDefaults.standard.set(true, forKey: "has_seen_intro")
    }
    
    func t(_ key: String) -> String {
        return key
    }
}

enum AIProvider: String, CaseIterable, Codable, Identifiable {
    case groq = "Groq"
    case gemini = "Gemini"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .groq: return "⚡ Groq Cloud (Siêu Tốc)"
        case .gemini: return "🌟 Google Gemini"
        }
    }
    
    var shortName: String {
        switch self {
        case .groq: return "Groq"
        case .gemini: return "Gemini"
        }
    }
}
