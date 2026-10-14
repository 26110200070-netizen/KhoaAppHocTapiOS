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
    @Published var isLoggedIn: Bool = false
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
    @Published var deepSeekServerUrl: String = "http://localhost:8000/v1"
    @Published var isDeepSeekConnected: Bool = true
    
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
        
        // Auto-login to default account
        self.isLoggedIn = true
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
    }
    
    func login(username: String, apiKey: String? = nil) {
        self.currentUser.username = username
        if let key = apiKey, !key.isEmpty {
            self.deepSeekApiKey = key
            self.isDeepSeekConnected = true
        }
        self.isLoggedIn = true
    }
    
    // Localization Helper
    func t(_ key: String) -> String {
        if currentLanguage == .english {
            return AppState.enStrings[key] ?? key
        }
        return AppState.viStrings[key] ?? key
    }
    
    private static let viStrings: [String: String] = [
        "home": "Trang chủ",
        "account": "Tài khoản",
        "study_theory": "Học lí thuyết",
        "do_exercise": "Làm bài tập",
        "focus_timer": "Treo máy tự học",
        "subjects": "Môn học",
        "grade": "Khối lớp",
        "chapters": "Chương bài",
        "midterm_exam": "Ôn thi giữa kỳ",
        "final_exam": "Ôn thi cuối kỳ",
        "logout": "Đăng xuất",
        "switch_account": "Chuyển tài khoản",
        "language": "Ngôn ngữ",
        "export_word": "Tải về Word (.docx)",
        "score": "Điểm số",
        "submit": "Nộp bài",
        "next": "Câu tiếp theo",
        "prev": "Câu trước"
    ]
    
    private static let enStrings: [String: String] = [
        "home": "Home",
        "account": "Account",
        "study_theory": "Theory Study",
        "do_exercise": "Practice Exercises",
        "focus_timer": "Focus Lock Mode",
        "subjects": "Subjects",
        "grade": "Grade",
        "chapters": "Chapters & Lessons",
        "midterm_exam": "Midterm Review",
        "final_exam": "Final Exam Review",
        "logout": "Log Out",
        "switch_account": "Switch Account",
        "language": "Language",
        "export_word": "Download Word (.docx)",
        "score": "Score",
        "submit": "Submit Test",
        "next": "Next Question",
        "prev": "Previous Question"
    ]
}
