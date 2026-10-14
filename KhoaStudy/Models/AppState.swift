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
    
    // DeepSeek API Configuration
    @Published var deepSeekApiKey: String = ""
    @Published var deepSeekServerUrl: String = "http://192.168.2.16:8000/v1"
    @Published var isDeepSeekConnected: Bool = false
    
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
        
        // Always start with intro on launch, and require login
        self.hasSeenIntro = false
        self.isLoggedIn = false
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
        UserDefaults.standard.set(false, forKey: "user_logged_in")
    }
    
    func login(username: String, apiKey: String? = nil) {
        self.currentUser.username = username
        if let key = apiKey, !key.isEmpty {
            self.deepSeekApiKey = key
        }
        self.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "user_logged_in")
    }
    
    func completeIntro() {
        self.hasSeenIntro = true
        UserDefaults.standard.set(true, forKey: "has_seen_intro")
    }
    
    func t(_ key: String) -> String {
        return key
    }
}
