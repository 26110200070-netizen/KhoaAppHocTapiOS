import Foundation

// MARK: - 1. Question Types for Standard Vietnam 2025 Exam Structure
public struct MultipleChoiceQuestion: Identifiable, Codable, Hashable {
    public var id: Int
    public var question: String
    public var options: [String] // Exactly 4 options A, B, C, D
    public var correctIndex: Int // 0, 1, 2, 3
    public var explanation: String
    
    public init(id: Int, question: String, options: [String], correctIndex: Int, explanation: String) {
        self.id = id
        self.question = question
        self.options = options
        self.correctIndex = correctIndex
        self.explanation = explanation
    }
}

public struct TrueFalseStatement: Identifiable, Codable, Hashable {
    public var id: String // "a", "b", "c", "d"
    public var statement: String
    public var isCorrectTrue: Bool
    public var explanation: String
    
    public init(id: String, statement: String, isCorrectTrue: Bool, explanation: String) {
        self.id = id
        self.statement = statement
        self.isCorrectTrue = isCorrectTrue
        self.explanation = explanation
    }
}

public struct TrueFalseQuestion: Identifiable, Codable, Hashable {
    public var id: Int
    public var context: String
    public var statements: [TrueFalseStatement] // Exactly 4 statements a, b, c, d
    
    public init(id: Int, context: String, statements: [TrueFalseStatement]) {
        self.id = id
        self.context = context
        self.statements = statements
    }
}

public struct ShortAnswerQuestion: Identifiable, Codable, Hashable {
    public var id: Int
    public var question: String
    public var acceptedAnswers: [String]
    public var unit: String?
    public var explanation: String
    
    public init(id: Int, question: String, acceptedAnswers: [String], unit: String? = nil, explanation: String) {
        self.id = id
        self.question = question
        self.acceptedAnswers = acceptedAnswers
        self.unit = unit
        self.explanation = explanation
    }
}

// MARK: - 2. Complete Generated Exam
public struct GeneratedExam: Identifiable, Codable {
    public var id: String = UUID().uuidString
    public var title: String
    public var grade: Int
    public var semester: Int
    public var subject: String
    public var focusTopic: String
    public var multipleChoice: [MultipleChoiceQuestion]
    public var trueFalse: [TrueFalseQuestion]
    public var shortAnswer: [ShortAnswerQuestion]
    public var createdAt: Date = Date()
    
    public var totalQuestionCount: Int {
        return multipleChoice.count + trueFalse.count + shortAnswer.count
    }
    
    public init(
        title: String,
        grade: Int,
        semester: Int,
        subject: String,
        focusTopic: String,
        multipleChoice: [MultipleChoiceQuestion],
        trueFalse: [TrueFalseQuestion],
        shortAnswer: [ShortAnswerQuestion]
    ) {
        self.id = UUID().uuidString
        self.title = title
        self.grade = grade
        self.semester = semester
        self.subject = subject
        self.focusTopic = focusTopic
        self.multipleChoice = multipleChoice
        self.trueFalse = trueFalse
        self.shortAnswer = shortAnswer
        self.createdAt = Date()
    }
}

// MARK: - 3. Curated Standard Fallback Provider (Never hangs or fails offline)
public struct CuratedStandardExamProvider {
    public static func getStandardExam(
        grade: Int,
        semester: Int,
        subject: String,
        focusTopic: String,
        mcCount: Int,
        tfCount: Int,
        saCount: Int
    ) -> GeneratedExam {
        let topicDisplay = focusTopic.isEmpty ? "Chương trình GDPT mới chuẩn SGK" : focusTopic
        let examTitle = "Đề Khảo Sát \(subject) • Lớp \(grade) (Học Kỳ \(semester))"
        
        var mcList: [MultipleChoiceQuestion] = []
        var tfList: [TrueFalseQuestion] = []
        var saList: [ShortAnswerQuestion] = []
        
        // Generate realistic subject-specific questions with LaTeX
        switch subject.lowercased() {
        case let s where s.contains("toán"):
            for i in 1...mcCount {
                mcList.append(MultipleChoiceQuestion(
                    id: i,
                    question: "Câu \(i): Tìm tập xác định của hàm số $y = \\frac{\\sqrt{x + \(i)}}{x - \(i + 1)}$.",
                    options: [
                        "$D = [-\(i); +\\infty) \\setminus \\{\(i + 1)\\}$",
                        "$D = (-\(i); +\\infty)$",
                        "$D = \\mathbb{R} \\setminus \\{\(i + 1)\\}$",
                        "$D = [\(i); +\\infty)$"
                    ],
                    correctIndex: 0,
                    explanation: "Điều kiện xác định: $x + \(i) \\ge 0 \\Leftrightarrow x \\ge -\(i)$ và mẫu thức $x - \(i + 1) \\ne 0 \\Leftrightarrow x \\ne \(i + 1)$. Do đó $D = [-\(i); +\\infty) \\setminus \\{\(i + 1)\\}$."
                ))
            }
            for i in 1...tfCount {
                tfList.append(TrueFalseQuestion(
                    id: i,
                    context: "Cho hàm số bậc hai $y = f(x) = x^2 - 2(\(i))x + \(i * i - 1)$ có đồ thị là parabol $(P)$. Xét tính đúng/sai của các mệnh đề sau:",
                    statements: [
                        TrueFalseStatement(id: "a", statement: "Tọa độ đỉnh của parabol $(P)$ là $I(\(i); -1)$.", isCorrectTrue: true, explanation: "Hoành độ đỉnh $x_I = -\\frac{b}{2a} = \(i)$, tung độ $y_I = f(\(i)) = -1$."),
                        TrueFalseStatement(id: "b", statement: "Hàm số đồng biến trên khoảng $(-\(i); +\\infty)$.", isCorrectTrue: false, explanation: "Do $a = 1 > 0$, hàm số đồng biến trên $(\(i); +\\infty)$, không phải $(-\(i); +\\infty)$."),
                        TrueFalseStatement(id: "c", statement: "Phương trình $f(x) = 0$ có hai nghiệm phân biệt $x_1, x_2$.", isCorrectTrue: true, explanation: "Biệt thức $\\Delta' = b'^2 - ac = (\(i))^2 - (\(i * i - 1)) = 1 > 0$ nên luôn có 2 nghiệm phân biệt."),
                        TrueFalseStatement(id: "d", statement: "Giá trị nhỏ nhất của hàm số trên $\\mathbb{R}$ bằng 0.", isCorrectTrue: false, explanation: "Giá trị nhỏ nhất tại đỉnh là $y = -1$, không phải $0$.")
                    ]
                ))
            }
            for i in 1...saCount {
                saList.append(ShortAnswerQuestion(
                    id: i,
                    question: "Câu \(i): Cho tam giác vuông có hai cạnh góc vuông lần lượt là \(3 * i)$ cm và \(4 * i)$ cm. Tính độ dài cạnh huyền của tam giác (cm).",
                    acceptedAnswers: ["\(5 * i)", "\(5 * i).0"],
                    unit: "cm",
                    explanation: "Áp dụng định lý Pythagoras: $c = \\sqrt{a^2 + b^2} = \\sqrt{(\(3*i))^2 + (\(4*i))^2} = \\sqrt{\(25 * i * i)} = \(5 * i)$ cm."
                ))
            }
            
        case let s where s.contains("vật lí") || s.contains("vật lý"):
            for i in 1...mcCount {
                mcList.append(MultipleChoiceQuestion(
                    id: i,
                    question: "Câu \(i): Một vật dao động điều hòa theo phương trình $x = \(4 + i) \\cos(2\\pi t + \\frac{\\pi}{\(i + 1)})$ (cm). Biên độ dao động của vật là:",
                    options: [
                        "$\(4 + i)$ cm",
                        "$\(2 * (4 + i))$ cm",
                        "$2\\pi$ cm",
                        "$\(i + 1)$ cm"
                    ],
                    correctIndex: 0,
                    explanation: "Phương trình tổng quát $x = A \\cos(\\omega t + \\varphi)$. Biên độ dao động là $A = \(4 + i)$ cm."
                ))
            }
            for i in 1...tfCount {
                tfList.append(TrueFalseQuestion(
                    id: i,
                    context: "Một vật có khối lượng $m = \(100 * i)$ g treo vào lò xo có độ cứng $k = \(20 * i)$ N/m kích thích dao động điều hòa. Lấy $\\pi^2 = 10$.",
                    statements: [
                        TrueFalseStatement(id: "a", statement: "Tần số góc của con lắc là $\\omega = \\sqrt{\\frac{k}{m}} = \\sqrt{200}$ rad/s.", isCorrectTrue: true, explanation: "Đổi $m = \(Double(100 * i)/1000.0)$ kg. $\\omega = \\sqrt{k/m} = \\sqrt{200}$ rad/s."),
                        TrueFalseStatement(id: "b", statement: "Chu kỳ dao động phụ thuộc vào biên độ dao động.", isCorrectTrue: false, explanation: "Chu kỳ dao động điều hòa $T = 2\\pi \\sqrt{m/k}$ chỉ phụ thuộc cấu tạo hệ, không phụ thuộc biên độ."),
                        TrueFalseStatement(id: "c", statement: "Tại vị trí cân bằng, vận tốc của vật đạt giá trị cực đại.", isCorrectTrue: true, explanation: "Vị trí cân bằng có $x = 0$, thế năng bằng $0$, động năng và vận tốc cực đại $v_{\\max} = \\omega A$."),
                        TrueFalseStatement(id: "d", statement: "Lực kéo về tác dụng lên vật tỉ lệ nghịch với li độ.", isCorrectTrue: false, explanation: "Lực kéo về $F = -kx$ tỉ lệ thuận với li độ và luôn hướng về vị trí cân bằng.")
                    ]
                ))
            }
            for i in 1...saCount {
                saList.append(ShortAnswerQuestion(
                    id: i,
                    question: "Câu \(i): Một sóng cơ có tần số $f = \(5 * i)$ Hz truyền với tốc độ $v = \(10 * i)$ m/s. Bước sóng $\\lambda$ của sóng là bao nhiêu mét?",
                    acceptedAnswers: ["2", "2.0", "2 m"],
                    unit: "m",
                    explanation: "Công thức bước sóng $\\lambda = \\frac{v}{f} = \\frac{\(10 * i)}{\(5 * i)} = 2$ m."
                ))
            }
            
        case let s where s.contains("hóa"):
            for i in 1...mcCount {
                mcList.append(MultipleChoiceQuestion(
                    id: i,
                    question: "Câu \(i): Kim loại nào sau đây có tính khử mạnh nhất trong dãy hoạt động hóa học?",
                    options: ["K (Kali)", "Fe (Sắt)", "Cu (Đồng)", "Ag (Bạc)"],
                    correctIndex: 0,
                    explanation: "Trong dãy điện hóa, tính khử giảm dần từ trái sang phải: $K > Na > Mg > Al > Zn > Fe > Cu > Ag$. Do đó Kali (K) có tính khử mạnh nhất."
                ))
            }
            for i in 1...tfCount {
                tfList.append(TrueFalseQuestion(
                    id: i,
                    context: "Tiến hành thí nghiệm cho mẫu kim loại Natri (Na) vào cốc nước cất chứa vài giọt dung dịch phenolphtalein.",
                    statements: [
                        TrueFalseStatement(id: "a", statement: "Mẩu Na nóng chảy thành giọt tròn nổi trên mặt nước và tan dần.", isCorrectTrue: true, explanation: "Do phản ứng tỏa nhiệt mạnh và Na có khối lượng riêng nhỏ hơn nước."),
                        TrueFalseStatement(id: "b", statement: "Dung dịch trong cốc chuyển sang màu xanh lục.", isCorrectTrue: false, explanation: "Phản ứng tạo NaOH là bazơ nên làm phenolphtalein chuyển sang màu hồng."),
                        TrueFalseStatement(id: "c", statement: "Khí không màu thoát ra trong thí nghiệm là khí Hydrogen ($H_2$).", isCorrectTrue: true, explanation: "Phương trình: $2Na + 2H_2O \\rightarrow 2NaOH + H_2\\uparrow$."),
                        TrueFalseStatement(id: "d", statement: "Phản ứng trên thuộc loại phản ứng nhiệt phân.", isCorrectTrue: false, explanation: "Đây là phản ứng oxi hóa - khử / thế kim loại với nước, không phải nhiệt phân.")
                    ]
                ))
            }
            for i in 1...saCount {
                saList.append(ShortAnswerQuestion(
                    id: i,
                    question: "Câu \(i): Hòa tan hoàn toàn \(2.3 * Double(i))$ gam Natri vào nước dư thu được bao nhiêu mol khí $H_2$?",
                    acceptedAnswers: ["\(0.05 * Double(i))"],
                    unit: "mol",
                    explanation: "$n_{Na} = \\frac{\(2.3 * Double(i))}{23} = \(0.1 * Double(i))$ mol. Suy ra $n_{H_2} = \\frac{1}{2} n_{Na} = \(0.05 * Double(i))$ mol."
                ))
            }
            
        default: // English, Biology, History, Geography
            for i in 1...mcCount {
                mcList.append(MultipleChoiceQuestion(
                    id: i,
                    question: "Câu \(i): Kiến thức trọng tâm môn \(subject) Lớp \(grade) Học kỳ \(semester) - Nội dung ôn tập: \(topicDisplay). Câu hỏi kiểm tra hiểu biết lý thuyết:",
                    options: [
                        "Phương án A: Khái niệm và định nghĩa chính xác theo chuẩn SGK.",
                        "Phương án B: Nhận định chưa đầy đủ các yếu tố cấu thành.",
                        "Phương án C: Giả định trái với quy luật thực nghiệm.",
                        "Phương án D: Hiện tượng chưa được kiểm chứng trong tài liệu."
                    ],
                    correctIndex: 0,
                    explanation: "Theo sách giáo khoa môn \(subject) Lớp \(grade), phương án A phản ánh chính xác định nghĩa và nguyên lý khoa học của chủ đề \(topicDisplay)."
                ))
            }
            for i in 1...tfCount {
                tfList.append(TrueFalseQuestion(
                    id: i,
                    context: "Dựa vào kiến thức chuyên đề '\(topicDisplay)' môn \(subject) Lớp \(grade):",
                    statements: [
                        TrueFalseStatement(id: "a", statement: "Đặc điểm cơ bản phù hợp với quy luật chung của chương trình học kỳ \(semester).", isCorrectTrue: true, explanation: "Đúng theo chuẩn kiến thức kỹ năng."),
                        TrueFalseStatement(id: "b", statement: "Mọi trường hợp ngoại lệ đều phủ định hoàn toàn lý thuyết nền tảng.", isCorrectTrue: false, explanation: "Sai vì lý thuyết tổng quát vẫn bảo toàn giá trị."),
                        TrueFalseStatement(id: "c", statement: "Nội dung này được áp dụng trực tiếp trong thực tiễn đời sống và sản xuất.", isCorrectTrue: true, explanation: "Đúng theo mục tiêu ứng dụng thực tiễn của SGK mới."),
                        TrueFalseStatement(id: "d", statement: "Kiến thức này chỉ áp dụng giới hạn trong phạm vi phòng thí nghiệm lý thuyết.", isCorrectTrue: false, explanation: "Sai vì có phạm vi ứng dụng rộng rãi.")
                    ]
                ))
            }
            for i in 1...saCount {
                saList.append(ShortAnswerQuestion(
                    id: i,
                    question: "Câu \(i): Điền số thứ tự của bước thực hiện quan trọng đầu tiên trong phương pháp nghiên cứu môn \(subject) (Điền 1, 2 hoặc 3):",
                    acceptedAnswers: ["1", "Bước 1"],
                    unit: "",
                    explanation: "Bước 1 luôn là quan sát và đặt câu hỏi nghiên cứu ban đầu."
                ))
            }
        }
        
        return GeneratedExam(
            title: examTitle,
            grade: grade,
            semester: semester,
            subject: subject,
            focusTopic: topicDisplay,
            multipleChoice: mcList,
            trueFalse: tfList,
            shortAnswer: saList
        )
    }
}
