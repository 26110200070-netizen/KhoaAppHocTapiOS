import Foundation
import SwiftUI

// MARK: - Educational Levels
enum SchoolLevel: String, CaseIterable, Codable {
    case thcs = "THCS (Lớp 6 - 9)"
    case thpt = "THPT (Lớp 10 - 12)"
}

// MARK: - Grades (Khối lớp)
enum SchoolGrade: Int, CaseIterable, Identifiable, Codable {
    case g6 = 6
    case g7 = 7
    case g8 = 8
    case g9 = 9
    case g10 = 10
    case g11 = 11
    case g12 = 12
    
    var id: Int { self.rawValue }
    
    var displayName: String {
        "Lớp \(self.rawValue)"
    }
    
    var level: SchoolLevel {
        self.rawValue <= 9 ? .thcs : .thpt
    }
}

// MARK: - Subject Type
enum SubjectCategory: String, CaseIterable, Identifiable, Codable {
    case math = "Toán Học"
    case physics = "Vật Lý"
    case chemistry = "Hóa Học"
    case biology = "Sinh Học"
    case literature = "Ngữ Văn"
    case english = "Tiếng Anh"
    case history = "Lịch Sử"
    case geography = "Địa Lý"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .math: return "function"
        case .physics: return "atom"
        case .chemistry: return "flame.fill"
        case .biology: return "leaf.fill"
        case .literature: return "book.closed.fill"
        case .english: return "globe.americas.fill"
        case .history: return "hourglass"
        case .geography: return "map.fill"
        }
    }
    
    var colorHex: String {
        switch self {
        case .math: return "#2CC58A"
        case .physics: return "#3B82F6"
        case .chemistry: return "#F97316"
        case .biology: return "#10B981"
        case .literature: return "#EC4899"
        case .english: return "#8B5CF6"
        case .history: return "#EAB308"
        case .geography: return "#06B6D4"
        }
    }
}

// MARK: - Formula / Note Item
struct FormulaItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var formulaText: String
    var notes: String
    var badge: String = "Quan Trọng"
}

// MARK: - Example Item
struct ExampleItem: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var question: String
    var solutionSteps: [String]
    var finalResult: String
}

// MARK: - Multiple Choice Question
struct QuizQuestion: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var prompt: String
    var options: [String]
    var correctIndex: Int
    var explanation: String
    var chapterName: String
    var lessonName: String
    
    var originTag: String {
        "Bài tập thuộc \(lessonName) - \(chapterName)"
    }
}

// MARK: - Lesson (Bài học)
struct Lesson: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var order: Int
    var title: String
    var summary: String
    var videoDuration: String
    var videoThumbnailUrl: String?
    var formulas: [FormulaItem]
    var examples: [ExampleItem]
    var questions: [QuizQuestion]
}

// MARK: - Chapter (Chương)
struct Chapter: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var order: Int
    var title: String
    var description: String
    var lessons: [Lesson]
    var midtermReviewQuestions: [QuizQuestion]
    var finalReviewQuestions: [QuizQuestion]
}

// MARK: - Subject Offering (Môn theo Khối Lớp)
struct SubjectCurriculum: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var category: SubjectCategory
    var grade: SchoolGrade
    var chapters: [Chapter]
}

// MARK: - Mock Curriculum Database
class CurriculumStore {
    static let shared = CurriculumStore()
    
    let allCurriculums: [SubjectCurriculum]
    
    init() {
        self.allCurriculums = CurriculumStore.generateCurriculum()
    }
    
    func getCurriculum(for category: SubjectCategory, grade: SchoolGrade) -> SubjectCurriculum? {
        allCurriculums.first(where: { $0.category == category && $0.grade == grade })
    }
    
    static func generateCurriculum() -> [SubjectCurriculum] {
        var list: [SubjectCurriculum] = []
        
        // 1. Toán Lớp 12
        let math12Chapters = [
            Chapter(
                order: 1,
                title: "Chương I: Ứng Dụng Đạo Hàm Khảo Sát Đồ Thị",
                description: "Tính đơn điệu, cực trị, giá trị lớn nhất - nhỏ nhất và tiệm cận của đồ thị hàm số.",
                lessons: [
                    Lesson(
                        order: 1,
                        title: "Bài 1: Sự đồng biến, nghịch biến của hàm số",
                        summary: "Quy tắc xét tính đơn điệu của hàm số dựa trên dấu của đạo hàm cấp một f'(x) trên khoảng K.",
                        videoDuration: "18:45",
                        formulas: [
                            FormulaItem(
                                title: "Điều kiện cần và đủ của tính đơn điệu",
                                formulaText: "f'(x) ≥ 0, ∀x ∈ K (dấu '=' tại hữu hạn điểm) ⟺ f(x) đồng biến trên K",
                                notes: "Lưu ý dấu bằng chỉ được xảy ra tại hữu hạn điểm độc lập.",
                                badge: "Trọng Tâm Thi"
                            ),
                            FormulaItem(
                                title: "Hàm bậc 3 y = ax³ + bx² + cx + d",
                                formulaText: "y' = 3ax² + 2bx + c. Đồng biến trên R ⟺ a > 0 và Δ' ≤ 0",
                                notes: "Nếu a chưa khác 0 thì cần xét trường hợp a = 0.",
                                badge: "Công Thức Nhanh"
                            )
                        ],
                        examples: [
                            ExampleItem(
                                question: "Tìm khoảng đồng biến của hàm số y = -x³ + 3x² - 1.",
                                solutionSteps: [
                                    "Bước 1: Tập xác định D = R.",
                                    "Bước 2: Tính đạo hàm y' = -3x² + 6x.",
                                    "Bước 3: Giải phương trình y' = 0 ⟺ -3x(x - 2) = 0 ⟺ x = 0 hoặc x = 2.",
                                    "Bước 4: Lập bảng xét dấu: y' mang dấu dương trên khoảng (0; 2)."
                                ],
                                finalResult: "Hàm số đồng biến trên khoảng (0; 2)."
                            )
                        ],
                        questions: [
                            QuizQuestion(
                                prompt: "Hàm số y = x³ - 3x + 2 đồng biến trên các khoảng nào sau đây?",
                                options: ["(-∞; -1) và (1; +∞)", "(-1; 1)", "(-∞; 1)", "(0; 2)"],
                                correctIndex: 0,
                                explanation: "Ta có y' = 3x² - 3. Cho y' > 0 ⟺ x² > 1 ⟺ x > 1 hoặc x < -1.",
                                chapterName: "Chương I: Ứng dụng đạo hàm",
                                lessonName: "Bài 1: Sự đồng biến nghịch biến"
                            ),
                            QuizQuestion(
                                prompt: "Cho hàm số f(x) có đạo hàm f'(x) = x(x - 1)²(x + 2). Số khoảng nghịch biến của hàm số là:",
                                options: ["1 khoảng", "2 khoảng", "3 khoảng", "0 khoảng"],
                                correctIndex: 0,
                                explanation: "Vì (x - 1)² ≥ 0 nên dấu f'(x) phụ thuộc x(x + 2). f'(x) < 0 ⟺ x ∈ (-2; 0). Do đó có đúng 1 khoảng nghịch biến.",
                                chapterName: "Chương I: Ứng dụng đạo hàm",
                                lessonName: "Bài 1: Sự đồng biến nghịch biến"
                            ),
                            QuizQuestion(
                                prompt: "Điều kiện để hàm số bậc bốn trùng phương y = ax⁴ + bx² + c có 3 điểm cực trị là:",
                                options: ["ab < 0", "ab > 0", "a > 0, b < 0", "b² - 4ac > 0"],
                                correctIndex: 0,
                                explanation: "Hàm số trùng phương có 3 cực trị khi và chỉ khi a.b < 0 (hai hệ số a và b trái dấu).",
                                chapterName: "Chương I: Ứng dụng đạo hàm",
                                lessonName: "Bài 1: Sự đồng biến nghịch biến"
                            ),
                            QuizQuestion(
                                prompt: "Đường tiệm cận ngang của đồ thị hàm số y = (2x + 1)/(x - 1) là:",
                                options: ["y = 2", "x = 1", "y = -1", "x = 2"],
                                correctIndex: 0,
                                explanation: "Bậc tử bằng bậc mẫu, lim (2x + 1)/(x - 1) khi x -> vô cùng = 2/1 = 2.",
                                chapterName: "Chương I: Ứng dụng đạo hàm",
                                lessonName: "Bài 1: Sự đồng biến nghịch biến"
                            ),
                            QuizQuestion(
                                prompt: "Giá trị lớn nhất của hàm số f(x) = x³ - 3x trên đoạn [0; 2] bằng:",
                                options: ["2", "0", "-2", "4"],
                                correctIndex: 0,
                                explanation: "f'(x) = 3x² - 3 = 0 ⟺ x = 1 ∈ [0; 2]. Ta có f(0) = 0, f(1) = -2, f(2) = 2. Max = 2.",
                                chapterName: "Chương I: Ứng dụng đạo hàm",
                                lessonName: "Bài 1: Sự đồng biến nghịch biến"
                            )
                        ]
                    ),
                    Lesson(
                        order: 2,
                        title: "Bài 2: Cực trị của hàm số",
                        summary: "Định nghĩa điểm cực đại, cực tiểu và các quy tắc tìm cực trị bằng đạo hàm cấp 1 và cấp 2.",
                        videoDuration: "22:10",
                        formulas: [
                            FormulaItem(
                                title: "Dấu hiệu I tìm cực trị",
                                formulaText: "Nếu y' đổi dấu từ + sang - qua x₀ thì x₀ là điểm Cực Đại",
                                notes: "Nếu y' đổi dấu từ - sang + qua x₀ thì x₀ là điểm Cực Tiểu.",
                                badge: "Quy Tắc Vàng"
                            )
                        ],
                        examples: [
                            ExampleItem(
                                question: "Tìm điểm cực trị của hàm số y = x⁴ - 2x² + 3.",
                                solutionSteps: [
                                    "y' = 4x³ - 4x = 4x(x² - 1) = 0 ⟺ x = 0 hoặc x = ±1.",
                                    "Qua x = -1 và x = 1 đạo hàm đổi dấu từ - sang + nên là điểm cực tiểu.",
                                    "Qua x = 0 đạo hàm đổi dấu từ + sang - nên là điểm cực đại."
                                ],
                                finalResult: "Hàm số đạt CĐ tại x = 0 và CT tại x = ±1."
                            )
                        ],
                        questions: [
                            QuizQuestion(
                                prompt: "Điểm cực đại của đồ thị hàm số y = -x³ + 3x + 1 là:",
                                options: ["(1; 3)", "(-1; -1)", "(0; 1)", "(2; -1)"],
                                correctIndex: 0,
                                explanation: "y' = -3x² + 3 = 0 ⟺ x = ±1. Điểm cực đại x = 1, y(1) = 3 -> Điểm (1; 3).",
                                chapterName: "Chương I: Ứng dụng đạo hàm",
                                lessonName: "Bài 2: Cực trị của hàm số"
                            )
                        ]
                    )
                ],
                midtermReviewQuestions: [
                    QuizQuestion(
                        prompt: "[Đề Giữa Kỳ] Cho hàm số y = f(x) có bảng biến thiên... Giá trị cực tiểu là:",
                        options: ["y = -3", "x = 2", "y = 4", "x = -1"],
                        correctIndex: 0,
                        explanation: "Giá trị cực tiểu là tung độ tại điểm cực tiểu: y_CT = -3.",
                        chapterName: "Chương I",
                        lessonName: "Đề Ôn Thi Giữa Kỳ"
                    )
                ],
                finalReviewQuestions: [
                    QuizQuestion(
                        prompt: "[Đề Cuối Kỳ] Số đường tiệm cận đứng và ngang của hàm số y = 1/(x² - 4) là:",
                        options: ["3 đường", "2 đường", "1 đường", "4 đường"],
                        correctIndex: 0,
                        explanation: "Có 2 tiệm cận đứng x = 2, x = -2 và 1 tiệm cận ngang y = 0. Tổng 3 đường.",
                        chapterName: "Chương I",
                        lessonName: "Đề Ôn Thi Cuối Kỳ"
                    )
                ]
            ),
            Chapter(
                order: 2,
                title: "Chương II: Hàm Số Lũy Thừa, Mũ Và Logarit",
                description: "Khái niệm lũy thừa, hàm số mũ, hàm số logarit và phương pháp giải phương trình mũ, logarit.",
                lessons: [
                    Lesson(
                        order: 1,
                        title: "Bài 1: Lũy thừa và hàm số lũy thừa",
                        summary: "Các tính chất của lũy thừa với số mũ thực, tập xác định của hàm lũy thừa y = x^α.",
                        videoDuration: "16:20",
                        formulas: [
                            FormulaItem(
                                title: "Tập xác định hàm số y = x^α",
                                formulaText: "α nguyên dương: D = R; α nguyên âm hoặc = 0: x ≠ 0; α không nguyên: x > 0",
                                notes: "Rất hay bẫy trong đề thi tốt nghiệp THPT!",
                                badge: "Bẫy Đề Thi"
                            )
                        ],
                        examples: [],
                        questions: [
                            QuizQuestion(
                                prompt: "Tập xác định của hàm số y = (x - 1)^(1/3) là:",
                                options: ["(1; +∞)", "[1; +∞)", "R \\ {1}", "R"],
                                correctIndex: 0,
                                explanation: "Vì số mũ 1/3 không nguyên nên điều kiện là x - 1 > 0 ⟺ x > 1.",
                                chapterName: "Chương II: Hàm số Mũ và Logarit",
                                lessonName: "Bài 1: Lũy thừa"
                            )
                        ]
                    )
                ],
                midtermReviewQuestions: [],
                finalReviewQuestions: []
            )
        ]
        
        list.append(SubjectCurriculum(category: .math, grade: .g12, chapters: math12Chapters))
        
        // 2. Vật Lý Lớp 12
        let physics12Chapters = [
            Chapter(
                order: 1,
                title: "Chương I: Dao Động Cơ",
                description: "Dao động điều hòa, con lắc lò xo, con lắc đơn, dao động tắt dần và cộng hưởng.",
                lessons: [
                    Lesson(
                        order: 1,
                        title: "Bài 1: Dao động điều hòa",
                        summary: "Phương trình x = A.cos(ωt + φ), vận tốc v = -ωA.sin(ωt + φ), gia tốc a = -ω²x.",
                        videoDuration: "20:15",
                        formulas: [
                            FormulaItem(
                                title: "Mối liên hệ độc lập thời gian",
                                formulaText: "A² = x² + (v/ω)²",
                                notes: "Vận tốc sớm pha π/2 so với li độ, gia tốc ngược pha với li độ.",
                                badge: "Trọng Tâm"
                            )
                        ],
                        examples: [],
                        questions: [
                            QuizQuestion(
                                prompt: "Một vật dao động điều hòa với phương trình x = 5cos(4πt) (cm). Biên độ và tần số góc là:",
                                options: ["A = 5 cm; ω = 4π rad/s", "A = 4 cm; ω = 5π rad/s", "A = 10 cm; ω = 2π rad/s", "A = 5 cm; ω = 2π rad/s"],
                                correctIndex: 0,
                                explanation: "Theo dạng tổng quát x = A.cos(ωt + φ), ta thấy ngay A = 5 cm và ω = 4π rad/s.",
                                chapterName: "Chương I: Dao Động Cơ",
                                lessonName: "Bài 1: Dao động điều hòa"
                            )
                        ]
                    )
                ],
                midtermReviewQuestions: [],
                finalReviewQuestions: []
            )
        ]
        list.append(SubjectCurriculum(category: .physics, grade: .g12, chapters: physics12Chapters))
        
        // 3. Tiếng Anh Lớp 12
        let english12Chapters = [
            Chapter(
                order: 1,
                title: "Unit 1: Life Stories We Admire",
                description: "Từ vựng về tiểu sử các danh nhân và thì Quá khứ đơn vs Quá khứ tiếp diễn.",
                lessons: [
                    Lesson(
                        order: 1,
                        title: "Grammar: Past Simple vs Past Continuous",
                        summary: "Cách dùng diễn tả hành động đang diễn ra trong quá khứ thì có hành động khác xen vào (When / While).",
                        videoDuration: "14:10",
                        formulas: [
                            FormulaItem(
                                title: "Cấu trúc với When & While",
                                formulaText: "While + S + was/were + V-ing, S + V-ed/V2",
                                notes: "When đi với hành động ngắn xen vào (V-ed).",
                                badge: "Ngữ Pháp Cơ Bản"
                            )
                        ],
                        examples: [],
                        questions: [
                            QuizQuestion(
                                prompt: "He _______ his homework when the phone rang.",
                                options: ["was doing", "did", "is doing", "has done"],
                                correctIndex: 0,
                                explanation: "Hành động đang xảy ra (was doing) thì hành động khác chen ngang (rang).",
                                chapterName: "Unit 1: Life Stories",
                                lessonName: "Grammar Review"
                            )
                        ]
                    )
                ],
                midtermReviewQuestions: [],
                finalReviewQuestions: []
            )
        ]
        list.append(SubjectCurriculum(category: .english, grade: .g12, chapters: english12Chapters))
        
        // 4. Các khối lớp khác (Lớp 6 đến Lớp 11)
        for g in SchoolGrade.allCases where g != .g12 {
            let cat = SubjectCategory.math
            let dummyChapters = [
                Chapter(
                    order: 1,
                    title: "Chương I: Kiến thức trọng tâm \(g.displayName)",
                    description: "Chương trình sách giáo khoa chuẩn bộ GD&ĐT cho khối \(g.displayName).",
                    lessons: [
                        Lesson(
                            order: 1,
                            title: "Bài 1: Giới thiệu và lý thuyết nền tảng",
                            summary: "Tóm tắt các định lý và định nghĩa căn bản trong sách giáo khoa.",
                            videoDuration: "15:00",
                            formulas: [
                                FormulaItem(
                                    title: "Công thức chuẩn SGK",
                                    formulaText: "Quy tắc áp dụng cho dạng bài tiêu biểu lớp \(g.rawValue)",
                                    notes: "Ghi nhớ các bước biến đổi căn bản."
                                )
                            ],
                            examples: [],
                            questions: [
                                QuizQuestion(
                                    prompt: "Câu hỏi ôn luyện kiến thức nền tảng môn \(cat.rawValue) khối \(g.displayName):",
                                    options: ["Đáp án đúng", "Đáp án sai 1", "Đáp án sai 2", "Đáp án sai 3"],
                                    correctIndex: 0,
                                    explanation: "Lời giải chi tiết giúp học sinh hiểu sâu bản chất bài học.",
                                    chapterName: "Chương I",
                                    lessonName: "Bài 1: Kiến thức nền tảng"
                                )
                            ]
                        )
                    ],
                    midtermReviewQuestions: [],
                    finalReviewQuestions: []
                )
            ]
            list.append(SubjectCurriculum(category: cat, grade: g, chapters: dummyChapters))
        }
        
        return list
    }
}
