import Foundation

// MARK: - 1. Question Types for Standard Vietnam 2025-2026 Exam Structure
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
    
    enum CodingKeys: String, CodingKey {
        case id, question, options, correctIndex, explanation
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intId = try? container.decode(Int.self, forKey: .id) {
            self.id = intId
        } else if let strId = try? container.decode(String.self, forKey: .id), let parsed = Int(strId.filter { $0.isNumber }) {
            self.id = parsed
        } else {
            self.id = 1
        }
        
        self.question = (try? container.decode(String.self, forKey: .question)) ?? ""
        self.options = (try? container.decode([String].self, forKey: .options)) ?? []
        
        if let intIdx = try? container.decode(Int.self, forKey: .correctIndex) {
            self.correctIndex = intIdx
        } else if let strIdx = try? container.decode(String.self, forKey: .correctIndex) {
            let upper = strIdx.trimmingCharacters(in: .whitespaces).uppercased()
            if upper.starts(with: "A") { self.correctIndex = 0 }
            else if upper.starts(with: "B") { self.correctIndex = 1 }
            else if upper.starts(with: "C") { self.correctIndex = 2 }
            else if upper.starts(with: "D") { self.correctIndex = 3 }
            else if let parsed = Int(upper) { self.correctIndex = parsed }
            else { self.correctIndex = 0 }
        } else {
            self.correctIndex = 0
        }
        
        self.explanation = (try? container.decode(String.self, forKey: .explanation)) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(question, forKey: .question)
        try container.encode(options, forKey: .options)
        try container.encode(correctIndex, forKey: .correctIndex)
        try container.encode(explanation, forKey: .explanation)
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
    
    enum CodingKeys: String, CodingKey {
        case id, statement, isCorrectTrue, explanation
        case label, text, isCorrect, correct
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let strId = try? container.decode(String.self, forKey: .id) {
            self.id = strId
        } else if let intId = try? container.decode(Int.self, forKey: .id) {
            self.id = String(intId)
        } else {
            self.id = "a"
        }
        
        if let stmt = try? container.decode(String.self, forKey: .statement) {
            self.statement = stmt
        } else if let label = try? container.decode(String.self, forKey: .label) {
            self.statement = label
        } else if let txt = try? container.decode(String.self, forKey: .text) {
            self.statement = txt
        } else {
            self.statement = ""
        }
        
        if let b = try? container.decode(Bool.self, forKey: .isCorrectTrue) {
            self.isCorrectTrue = b
        } else if let b = try? container.decode(Bool.self, forKey: .isCorrect) {
            self.isCorrectTrue = b
        } else if let b = try? container.decode(Bool.self, forKey: .correct) {
            self.isCorrectTrue = b
        } else if let str = try? container.decode(String.self, forKey: .isCorrectTrue) {
            self.isCorrectTrue = str.lowercased().contains("true") || str.lowercased().contains("đúng")
        } else {
            self.isCorrectTrue = true
        }
        
        self.explanation = (try? container.decode(String.self, forKey: .explanation)) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(statement, forKey: .statement)
        try container.encode(isCorrectTrue, forKey: .isCorrectTrue)
        try container.encode(explanation, forKey: .explanation)
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
    
    enum CodingKeys: String, CodingKey {
        case id, context, statements
        case statement, question, items
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intId = try? container.decode(Int.self, forKey: .id) {
            self.id = intId
        } else if let strId = try? container.decode(String.self, forKey: .id), let parsed = Int(strId.filter { $0.isNumber }) {
            self.id = parsed
        } else {
            self.id = 1
        }
        
        if let ctx = try? container.decode(String.self, forKey: .context) {
            self.context = ctx
        } else if let stmt = try? container.decode(String.self, forKey: .statement) {
            self.context = stmt
        } else if let q = try? container.decode(String.self, forKey: .question) {
            self.context = q
        } else {
            self.context = ""
        }
        
        if let stmts = try? container.decode([TrueFalseStatement].self, forKey: .statements) {
            self.statements = stmts
        } else if let items = try? container.decode([TrueFalseStatement].self, forKey: .items) {
            self.statements = items
        } else {
            self.statements = []
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(context, forKey: .context)
        try container.encode(statements, forKey: .statements)
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
    
    enum CodingKeys: String, CodingKey {
        case id, question, acceptedAnswers, unit, explanation
        case correctAnswer, answer
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let intId = try? container.decode(Int.self, forKey: .id) {
            self.id = intId
        } else if let strId = try? container.decode(String.self, forKey: .id), let parsed = Int(strId.filter { $0.isNumber }) {
            self.id = parsed
        } else {
            self.id = 1
        }
        
        self.question = (try? container.decode(String.self, forKey: .question)) ?? ""
        
        if let answers = try? container.decode([String].self, forKey: .acceptedAnswers) {
            self.acceptedAnswers = answers
        } else if let strAns = try? container.decode(String.self, forKey: .correctAnswer) {
            self.acceptedAnswers = [strAns]
        } else if let strAns = try? container.decode(String.self, forKey: .answer) {
            self.acceptedAnswers = [strAns]
        } else if let doubleAns = try? container.decode(Double.self, forKey: .correctAnswer) {
            self.acceptedAnswers = [String(doubleAns)]
        } else if let intAns = try? container.decode(Int.self, forKey: .correctAnswer) {
            self.acceptedAnswers = [String(intAns)]
        } else {
            self.acceptedAnswers = []
        }
        
        self.unit = try? container.decode(String.self, forKey: .unit)
        self.explanation = (try? container.decode(String.self, forKey: .explanation)) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(question, forKey: .question)
        try container.encode(acceptedAnswers, forKey: .acceptedAnswers)
        try container.encodeIfPresent(unit, forKey: .unit)
        try container.encode(explanation, forKey: .explanation)
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
    
    enum CodingKeys: String, CodingKey {
        case id, title, grade, semester, subject, focusTopic, multipleChoice, trueFalse, shortAnswer, createdAt
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(String.self, forKey: .id)) ?? UUID().uuidString
        self.title = (try? container.decode(String.self, forKey: .title)) ?? "Đề Khảo Sát Kiến Thức"
        self.grade = (try? container.decode(Int.self, forKey: .grade)) ?? 12
        self.semester = (try? container.decode(Int.self, forKey: .semester)) ?? 1
        self.subject = (try? container.decode(String.self, forKey: .subject)) ?? "Toán"
        self.focusTopic = (try? container.decode(String.self, forKey: .focusTopic)) ?? ""
        self.multipleChoice = (try? container.decode([MultipleChoiceQuestion].self, forKey: .multipleChoice)) ?? []
        self.trueFalse = (try? container.decode([TrueFalseQuestion].self, forKey: .trueFalse)) ?? []
        self.shortAnswer = (try? container.decode([ShortAnswerQuestion].self, forKey: .shortAnswer)) ?? []
        self.createdAt = (try? container.decode(Date.self, forKey: .createdAt)) ?? Date()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(grade, forKey: .grade)
        try container.encode(semester, forKey: .semester)
        try container.encode(subject, forKey: .subject)
        try container.encode(focusTopic, forKey: .focusTopic)
        try container.encode(multipleChoice, forKey: .multipleChoice)
        try container.encode(trueFalse, forKey: .trueFalse)
        try container.encode(shortAnswer, forKey: .shortAnswer)
        try container.encode(createdAt, forKey: .createdAt)
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
        
        // Generate realistic, diverse subject-specific questions with LaTeX
        switch subject.lowercased() {
        case let s where s.contains("toán"):
            let mathMC: [(q: String, opts: [String], ans: Int, exp: String)]
            let mathTF: [(ctx: String, stmts: [(id: String, s: String, t: Bool, e: String)])]
            let mathSA: [(q: String, ans: [String], u: String, exp: String)]
            
            if grade == 11 {
                // CHUYÊN ĐỀ LỚP 11: Lượng giác, Cấp số cộng/nhân, Giới hạn, Hình không gian
                mathMC = [
                    (
                        "Tập xác định của hàm số lượng giác $y = \\tan(x - \\frac{\\pi}{4})$ là:",
                        ["$D = \\mathbb{R} \\setminus \\{\\frac{3\\pi}{4} + k\\pi, k \\in \\mathbb{Z}\\}$", "$D = \\mathbb{R} \\setminus \\{\\frac{\\pi}{4} + k\\pi\\}$", "$D = \\mathbb{R} \\setminus \\{\\frac{\\pi}{2} + k\\pi\\}$", "$D = \\mathbb{R}$"],
                        0,
                        "Điều kiện: $x - \\frac{\\pi}{4} \\ne \\frac{\\pi}{2} + k\\pi \\Leftrightarrow x \\ne \\frac{3\\pi}{4} + k\\pi$ ($k \\in \\mathbb{Z}$)."
                    ),
                    (
                        "Nghiệm của phương trình lượng giác cơ bản $\\sin x = \\frac{1}{2}$ là:",
                        ["$x = \\frac{\\pi}{6} + k2\\pi$ hoặc $x = \\frac{5\\pi}{6} + k2\\pi$", "$x = \\frac{\\pi}{3} + k2\\pi$", "$x = \\pm \\frac{\\pi}{6} + k2\\pi$", "$x = \\frac{\\pi}{6} + k\\pi$"],
                        0,
                        "Ta có $\\sin x = \\sin(\\frac{\\pi}{6}) \\Leftrightarrow x = \\frac{\\pi}{6} + k2\\pi$ hoặc $x = \\pi - \\frac{\\pi}{6} + k2\\pi = \\frac{5\\pi}{6} + k2\\pi$ ($k \\in \\mathbb{Z}$)."
                    ),
                    (
                        "Cho cấp số cộng $(u_n)$ có số hạng đầu $u_1 = 3$ và công sai $d = 2$. Giá trị của số hạng $u_5$ là:",
                        ["$11$", "$13$", "$10$", "$9$"],
                        0,
                        "Công thức số hạng tổng quát $u_n = u_1 + (n - 1)d \\Rightarrow u_5 = 3 + 4 \\times 2 = 11$."
                    ),
                    (
                        "Tính giới hạn $L = \\lim_{x \\to 2} \\frac{x^2 - 4}{x - 2}$ có kết quả là:",
                        ["$4$", "$2$", "$0$", "Không tồn tại"],
                        0,
                        "Ta có $\\frac{x^2 - 4}{x - 2} = \\frac{(x - 2)(x + 2)}{x - 2} = x + 2$. Khi $x \\to 2$, giới hạn bằng $2 + 2 = 4$."
                    ),
                    (
                        "Cho cấp số nhân $(u_n)$ có số hạng đầu $u_1 = 2$ và công bội $q = 3$. Giá trị của $u_3$ là:",
                        ["$18$", "$12$", "$6$", "$54$"],
                        0,
                        "Số hạng tổng quát $u_n = u_1 \\times q^{n-1} \\Rightarrow u_3 = 2 \\times 3^2 = 18$."
                    ),
                    (
                        "Tập giá trị của hàm số $y = 3\\cos x - 2$ là đoạn:",
                        ["$[-5; 1]$", "$[-1; 5]$", "$[-3; 3]$", "$[-2; 3]$"],
                        0,
                        "Vì $-1 \\le \\cos x \\le 1 \\Rightarrow -3 \\le 3\\cos x \\le 3 \\Rightarrow -5 \\le 3\\cos x - 2 \\le 1$. Vậy tập giá trị là $[-5; 1]$."
                    ),
                    (
                        "Trong không gian, cho hai đường thẳng phân biệt $a$ và $b$ cùng song song với mặt phẳng $(P)$. Khẳng định nào sau đây là ĐÚNG?",
                        ["$a$ và $b$ có thể song song, cắt nhau hoặc chéo nhau", "$a$ và $b$ chắc chắn song song với nhau", "$a$ và $b$ chắc chắn cắt nhau", "$a$ và $b$ chéo nhau"],
                        0,
                        "Hai đường thẳng cùng song song với một mặt phẳng thì có thể song song, cắt nhau hoặc chéo nhau trong không gian."
                    ),
                    (
                        "Một tổ gồm 5 học sinh nam và 5 học sinh nữ. Chọn ngẫu nhiên 3 học sinh. Xác suất để chọn được ít nhất 1 học sinh nữ là:",
                        ["$\\frac{11}{12}$", "$\\frac{1}{12}$", "$\\frac{5}{6}$", "$\\frac{1}{2}$"],
                        0,
                        "Số phần tử không gian mẫu $n(\\Omega) = C_{10}^3 = 120$. Biến cố đối cả 3 đều là nam: $C_5^3 = 10$. Xác suất $P = 1 - \\frac{10}{120} = \\frac{11}{12}$."
                    )
                ]
                
                mathTF = [
                    (
                        "Cho cấp số cộng $(u_n)$ có số hạng đầu $u_1 = 2$ và công sai $d = 3$. Xét tính đúng/sai của các mệnh đề sau:",
                        [
                            ("a", "Số hạng tổng quát của cấp số cộng là $u_n = 3n - 1$.", true, "Ta có $u_n = u_1 + (n - 1)d = 2 + 3(n - 1) = 3n - 1$."),
                            ("b", "Số hạng thứ 10 là $u_{10} = 29$.", true, "Thay $n = 10$ ta có $u_{10} = 3(10) - 1 = 29$."),
                            ("c", "Tổng của 10 số hạng đầu tiên là $S_{10} = 155$.", true, "Tổng $S_{10} = \\frac{10 \\times (u_1 + u_{10})}{2} = \\frac{10 \\times (2 + 29)}{2} = 155$."),
                            ("d", "Số 100 là một số hạng của cấp số cộng $(u_n)$.", false, "Nếu $3n - 1 = 100 \\Rightarrow 3n = 101 \\Rightarrow n = \\frac{101}{3} \\notin \\mathbb{N}^*$ nên 100 không phải số hạng.")
                        ]
                    ),
                    (
                        "Cho hình chóp $S.ABCD$ có đáy $ABCD$ là hình bình hành tâm $O$. Gọi $M, N$ lần lượt là trung điểm của $SA$ và $SC$.",
                        [
                            ("a", "Đường thẳng $MN$ song song với mặt phẳng $(ABCD)$.", true, "$MN$ là đường trung bình tam giác $SAC$ nên $MN \\parallel AC \\Rightarrow MN \\parallel (ABCD)$."),
                            ("b", "Đoạn thẳng $SO$ đi qua trung điểm của đoạn thẳng $MN$.", true, "Trong tam giác $SAC$, đường trung tuyến $SO$ cắt đường trung bình $MN$ tại trung điểm."),
                            ("c", "Mặt phẳng $(BMN)$ cắt hình chóp theo thiết diện là một hình thang.", true, "Thiết diện tạo bởi $(BMN)$ với hình chóp là tứ giác có hai cạnh đối song song nên là hình thang."),
                            ("d", "Giao tuyến của $(SAB)$ và $(SCD)$ là đường thẳng đi qua $S$ và cắt $AB$.", false, "Vì $AB \\parallel CD$ nên giao tuyến là đường thẳng qua $S$ và song song với $AB, CD$.")
                        ]
                    )
                ]
                
                mathSA = [
                    (
                        "Cho cấp số cộng $(u_n)$ có $u_1 = 5$ và công sai $d = 4$. Tính số hạng $u_{15}$.",
                        ["61", "61.0"],
                        "",
                        "$u_{15} = u_1 + 14d = 5 + 14 \\times 4 = 61$."
                    ),
                    (
                        "Tính giới hạn của dãy số $L = \\lim \\frac{4n^2 + 3n - 1}{2n^2 + 5}$.",
                        ["2", "2.0"],
                        "",
                        "Chia cả tử và mẫu cho $n^2$: $L = \\lim \\frac{4 + 3/n - 1/n^2}{2 + 5/n^2} = \\frac{4}{2} = 2$."
                    ),
                    (
                        "Cho phương trình $\\cos(2x) = 1$. Số nghiệm của phương trình thuộc đoạn $[0; 2\\pi]$ là bao nhiêu nghiệm?",
                        ["3"],
                        "nghiệm",
                        "Phương trình tương đương $2x = k2\\pi \\Leftrightarrow x = k\\pi$. Trên $[0; 2\\pi]$ có 3 nghiệm: $x = 0, x = \\pi, x = 2\\pi$."
                    )
                ]
            } else {
                // CHUYÊN ĐỀ LỚP 12: Đạo hàm, Khối tròn xoay, Tích phân, Oxyz
                mathMC = [
                    (
                        "Tìm tập xác định của hàm số $y = \\frac{\\sqrt{x + 2}}{x - 3}$.",
                        ["$D = [-2; +\\infty) \\setminus \\{3\\}$", "$D = (-2; +\\infty)$", "$D = \\mathbb{R} \\setminus \\{3\\}$", "$D = [2; +\\infty)$"],
                        0,
                        "Điều kiện: $x + 2 \\ge 0 \\Leftrightarrow x \\ge -2$ và $x - 3 \\ne 0 \\Leftrightarrow x \\ne 3$. Vậy $D = [-2; +\\infty) \\setminus \\{3\\}$."
                    ),
                    (
                        "Cho hàm số $y = x^3 - 3x^2 + 2$. Điểm cực tiểu của đồ thị hàm số có tọa độ là:",
                        ["$(2; -2)$", "$(0; 2)$", "$(1; 0)$", "$(-2; 2)$"],
                        0,
                        "Ta có $y' = 3x^2 - 6x = 3x(x - 2)$. $y' = 0 \\Leftrightarrow x = 0$ hoặc $x = 2$. Bảng biến thiên cho thấy cực tiểu tại $x = 2 \\Rightarrow y(2) = -2$."
                    ),
                    (
                        "Đường tiệm cận đứng của đồ thị hàm số $y = \\frac{2x + 1}{x - 1}$ là đường thẳng:",
                        ["$x = 1$", "$y = 2$", "$x = -1$", "$y = 1$"],
                        0,
                        "Nghiệm của mẫu số là $x = 1$ và tử số tại $x=1$ bằng $3 \\ne 0$. Do đó tiệm cận đứng là đường thẳng $x = 1$."
                    ),
                    (
                        "Giá trị lớn nhất của hàm số $f(x) = x^4 - 2x^2 + 3$ trên đoạn $[0; 2]$ bằng:",
                        ["$11$", "$3$", "$2$", "$19$"],
                        0,
                        "Ta có $f'(x) = 4x^3 - 4x = 4x(x^2 - 1) = 0 \\Leftrightarrow x = 0, x = 1$ trên $[0; 2]$. Ta có $f(0) = 3$, $f(1) = 2$, $f(2) = 11$. Vậy $\\max = 11$."
                    ),
                    (
                        "Trong không gian $Oxyz$, cho $A(1; 2; 3)$ và $B(3; 0; 1)$. Tọa độ trung điểm $M$ của đoạn thẳng $AB$ là:",
                        ["$M(2; 1; 2)$", "$M(4; 2; 4)$", "$M(2; -2; -2)$", "$M(1; -1; -1)$"],
                        0,
                        "Tọa độ trung điểm $M = (\\frac{1+3}{2}; \\frac{2+0}{2}; \\frac{3+1}{2}) = (2; 1; 2)$."
                    ),
                    (
                        "Tập nghiệm của phương trình $\\log_2(x - 1) = 3$ là:",
                        ["$S = \\{9\\}$", "$S = \\{7\\}$", "$S = \\{8\\}$", "$S = \\{10\\}$"],
                        0,
                        "Điều kiện $x > 1$. Phương trình tương đương $x - 1 = 2^3 = 8 \\Leftrightarrow x = 9$ (thỏa mãn)."
                    ),
                    (
                        "Tính tích phân $I = \\int_0^1 (2x + 1) dx$ có kết quả là:",
                        ["$2$", "$1$", "$3$", "$4$"],
                        0,
                        "$I = [x^2 + x]_0^1 = (1 + 1) - 0 = 2$."
                    ),
                    (
                        "Một tổ gồm 6 nam và 4 nữ. Chọn ngẫu nhiên 2 học sinh. Xác suất để chọn được 1 nam và 1 nữ là:",
                        ["$\\frac{8}{15}$", "$\\frac{7}{15}$", "$\\frac{1}{2}$", "$\\frac{2}{5}$"],
                        0,
                        "Số phần tử không gian mẫu $n(\\Omega) = C_{10}^2 = 45$. Số cách chọn 1 nam 1 nữ là $C_6^1 \\cdot C_4^1 = 24$. Xác suất $P = \\frac{24}{45} = \\frac{8}{15}$."
                    )
                ]
                
                mathTF = [
                    (
                        "Cho hàm số bậc ba $y = f(x) = x^3 - 3x + 1$ có đồ thị $(C)$. Xét tính đúng/sai của các khẳng định sau:",
                        [
                            ("a", "Hàm số đồng biến trên khoảng $(-\\infty; -1)$ và $(1; +\\infty)$.", true, "Đạo hàm $y' = 3x^2 - 3 > 0$ khi $x < -1$ hoặc $x > 1$."),
                            ("b", "Điểm cực đại của đồ thị hàm số là $M(-1; 3)$.", true, "Tại $x = -1$, $y(-1) = (-1)^3 - 3(-1) + 1 = 3$."),
                            ("c", "Đồ thị hàm số $(C)$ đi qua gốc tọa độ $O(0; 0)$.", false, "Khi $x = 0$, $y = 1 \\ne 0$ nên đồ thị không đi qua gốc tọa độ."),
                            ("d", "Phương trình $f(x) = 0$ có đúng 1 nghiệm thực.", false, "Giá trị cực trị $y_{CĐ} = 3 > 0$ và $y_{CT} = -1 < 0$ nên phương trình có 3 nghiệm thực phân biệt.")
                        ]
                    ),
                    (
                        "Trong không gian tọa độ $Oxyz$, cho mặt phẳng $(P): 2x - y + 2z - 5 = 0$ và điểm $A(1; 1; 2)$.",
                        [
                            ("a", "Véctơ pháp tuyến của mặt phẳng $(P)$ là $\\vec{n} = (2; -1; 2)$.", true, "Hệ số trước $x, y, z$ trong phương trình tổng quát là $(2; -1; 2)$."),
                            ("b", "Điểm $A$ thuộc mặt phẳng $(P)$.", false, "Thay tọa độ $A$ vào: $2(1) - 1 + 2(2) - 5 = 0$ nên $A \\in (P)$."),
                            ("c", "Khoảng cách từ gốc tọa độ $O(0; 0; 0)$ đến mặt phẳng $(P)$ bằng $\\frac{5}{3}$.", true, "$d(O, (P)) = \\frac{|-5|}{\\sqrt{2^2 + (-1)^2 + 2^2}} = \\frac{5}{3}$."),
                            ("d", "Mặt phẳng $(Q): 2x - y + 2z + 1 = 0$ cắt mặt phẳng $(P)$.", false, "Hai mặt phẳng có cùng vectơ pháp tuyến và khác hệ số tự do nên song song với nhau.")
                        ]
                    )
                ]
                
                mathSA = [
                    (
                        "Cho hàm số $y = -x^3 + 3x^2 + 9x - 1$. Giá trị cực đại của hàm số bằng bao nhiêu?",
                        ["26", "26.0"],
                        "",
                        "Đạo hàm $y' = -3x^2 + 6x + 9 = 0 \\Leftrightarrow x = -1$ hoặc $x = 3$. Điểm cực đại tại $x = 3 \\Rightarrow y_{CĐ} = -27 + 27 + 27 - 1 = 26$."
                    ),
                    (
                        "Trong không gian $Oxyz$, cho mặt phẳng $(P): 2x - 2y + z + 5 = 0$. Khoảng cách từ điểm $M(1; 2; 3)$ đến $(P)$ bằng bao nhiêu?",
                        ["2", "2.0"],
                        "",
                        "$d(M, P) = \\frac{|2(1) - 2(2) + 3 + 5|}{\\sqrt{2^2 + (-2)^2 + 1^2}} = \\frac{6}{3} = 2$."
                    ),
                    (
                        "Một người gửi 100 triệu đồng vào ngân hàng với lãi suất 6%/năm theo thể thức lãi kép. Sau 2 năm, số tiền lãi người đó nhận được là bao nhiêu triệu đồng? (Làm tròn 2 chữ số thập phân)",
                        ["12.36"],
                        "triệu đồng",
                        "Tổng số tiền sau 2 năm: $T = 100 \\times (1 + 0.06)^2 = 112.36$ triệu đồng. Tiền lãi là $112.36 - 100 = 12.36$ triệu đồng."
                    )
                ]
            }
            
            if saCount > 0 {
            
                for i in 1...saCount {
                let item = mathSA[(i - 1) % mathSA.count]
                saList.append(ShortAnswerQuestion(
                    id: i,
                    question: "Câu \(i): \(item.q)",
                    acceptedAnswers: item.ans,
                    unit: item.u.isEmpty ? nil : item.u,
                    explanation: item.exp
                ))
                }
            }
            
        case let s where s.contains("vật lí") || s.contains("vật lý"):
            let physMC: [(q: String, opts: [String], ans: Int, exp: String)] = [
                (
                    "Một vật dao động điều hòa theo phương trình $x = 5\\cos(4\\pi t + \\frac{\\pi}{3})$ (cm). Biên độ dao động của vật là:",
                    ["$5$ cm", "$10$ cm", "$4\\pi$ cm", "$\\frac{\\pi}{3}$ cm"],
                    0,
                    "Phương trình $x = A\\cos(\\omega t + \\varphi)$, biên độ $A = 5$ cm."
                ),
                (
                    "Chu kỳ dao động điều hòa của con lắc lò xo có khối lượng $m$ và độ cứng $k$ được xác định bởi công thức:",
                    ["$T = 2\\pi \\sqrt{\\frac{m}{k}}$", "$T = 2\\pi \\sqrt{\\frac{k}{m}}$", "$T = \\frac{1}{2\\pi} \\sqrt{\\frac{m}{k}}$", "$T = 2\\pi \\sqrt{\\frac{g}{l}}$"],
                    0,
                    "Công thức chu kỳ con lắc lò xo là $T = 2\\pi \\sqrt{\\frac{m}{k}}$."
                ),
                (
                    "Bước sóng $\\lambda$ là khoảng cách giữa hai điểm gần nhau nhất trên cùng một phương truyền sóng mà dao động tại hai điểm đó:",
                    ["Cùng pha", "Ngược pha", "Vuông pha", "Lệch pha bất kỳ"],
                    0,
                    "Định nghĩa bước sóng là quãng đường sóng truyền đi trong 1 chu kỳ, tương đương khoảng cách giữa hai điểm gần nhất trên phương truyền sóng dao động cùng pha."
                ),
                (
                    "Trong thí nghiệm Y-âng về giao thoa ánh sáng, khoảng vân $i$ được tính bằng công thức:",
                    ["$i = \\frac{\\lambda D}{a}$", "$i = \\frac{\\lambda a}{D}$", "$i = \\frac{a D}{\\lambda}$", "$i = \\lambda a D$"],
                    0,
                    "Công thức khoảng vân là $i = \\frac{\\lambda D}{a}$."
                )
            ]
            
            if mcCount > 0 {
            
                for i in 1...mcCount {
                let item = physMC[(i - 1) % physMC.count]
                mcList.append(MultipleChoiceQuestion(
                    id: i,
                    question: "Câu \(i): \(item.q)",
                    options: item.opts,
                    correctIndex: item.ans,
                    explanation: item.exp
                ))
                }
            }
            
            if tfCount > 0 {
            
                for i in 1...tfCount {
                tfList.append(TrueFalseQuestion(
                    id: i,
                    context: "Một con lắc lò xo gồm vật nặng khối lượng $m = 200$ g và lò xo có độ cứng $k = 50$ N/m dao động điều hòa trên mặt phẳng ngang không ma sát. Lấy $\\pi^2 = 10$.",
                    statements: [
                        TrueFalseStatement(id: "a", statement: "Tần số góc của dao động là $\\omega = 5\\sqrt{10}$ rad/s.", isCorrectTrue: true, explanation: "$\\omega = \\sqrt{\\frac{k}{m}} = \\sqrt{\\frac{50}{0.2}} = \\sqrt{250} = 5\\sqrt{10}$ rad/s."),
                        TrueFalseStatement(id: "b", statement: "Khi vật đi qua vị trí cân bằng, thế năng đàn hồi đạt giá trị cực đại.", isCorrectTrue: false, explanation: "Tại VTCB $x = 0$, thế năng bằng $0$, động năng đạt cực đại."),
                        TrueFalseStatement(id: "c", statement: "Cơ năng của con lắc được bảo toàn trong quá trình dao động.", isCorrectTrue: true, explanation: "Do không có ma sát và lực cản nên cơ năng bảo toàn."),
                        TrueFalseStatement(id: "d", statement: "Chu kỳ dao động tăng khi tăng biên độ dao động.", isCorrectTrue: false, explanation: "Chu kỳ $T$ chỉ phụ thuộc $m$ và $k$, không phụ thuộc biên độ $A$.")
                    ]
                ))
                }
            }
            
            if saCount > 0 {
            
                for i in 1...saCount {
                saList.append(ShortAnswerQuestion(
                    id: i,
                    question: "Câu \(i): Một sóng cơ truyền trên mặt nước có tần số $f = 50$ Hz và vận tốc truyền sóng $v = 1.5$ m/s. Bước sóng của sóng bằng bao nhiêu cm?",
                    acceptedAnswers: ["3", "3.0", "3 cm"],
                    unit: "cm",
                    explanation: "Bước sóng $\\lambda = \\frac{v}{f} = \\frac{1.5}{50} = 0.03$ m = $3$ cm."
                ))
                }
            }
            
        case let s where s.contains("hóa"):
            let chemMC: [(q: String, opts: [String], ans: Int, exp: String)] = [
                (
                    "Este etyl axetat có công thức cấu tạo thu gọn là:",
                    ["$CH_3COOC_2H_5$", "$C_2H_5COOCH_3$", "$HCOOC_2H_5$", "$CH_3COOCH_3$"],
                    0,
                    "Etyl axetat được tạo từ axit axetic ($CH_3COOH$) và ancol etylic ($C_2H_5OH$), công thức là $CH_3COOC_2H_5$."
                ),
                (
                    "Dung dịch chất nào sau đây làm quỳ tím chuyển sang màu xanh?",
                    ["Metylamin ($CH_3NH_2$)", "Axit axetic ($CH_3COOH$)", "Glyxin ($H_2N-CH_2-COOH$)", "Ancol etylic ($C_2H_5OH$)"],
                    0,
                    "Metylamin có tính bazơ mạnh hơn amoniac nên làm quỳ tím chuyển xanh."
                ),
                (
                    "Kim loại nào sau đây có tính khử mạnh nhất trong dãy hoạt động hóa học?",
                    ["K (Kali)", "Fe (Sắt)", "Cu (Đồng)", "Ag (Bạc)"],
                    0,
                    "Theo dãy điện hóa kim loại: $K > Na > Mg > Al > Zn > Fe > Cu > Ag$."
                ),
                (
                    "Thủy phân hoàn toàn tinh bột trong môi trường axit thu được monosaccarit nào sau đây?",
                    ["Glucozơ", "Fructozơ", "Saccarozơ", "Mantozơ"],
                    0,
                    "Tinh bột $(C_6H_{10}O_5)_n$ khi thủy phân hoàn toàn tạo thành glucozơ ($C_6H_{12}O_6$)."
                )
            ]
            
            if mcCount > 0 {
            
                for i in 1...mcCount {
                let item = chemMC[(i - 1) % chemMC.count]
                mcList.append(MultipleChoiceQuestion(
                    id: i,
                    question: "Câu \(i): \(item.q)",
                    options: item.opts,
                    correctIndex: item.ans,
                    explanation: item.exp
                ))
                }
            }
            
            if tfCount > 0 {
            
                for i in 1...tfCount {
                tfList.append(TrueFalseQuestion(
                    id: i,
                    context: "Tiến hành thí nghiệm tráng bạc: Cho $1$ ml dung dịch $AgNO_3$ 1% vào ống nghiệm sạch, thêm từng giọt dung dịch $NH_3$ đến khi kết tủa tan hết. Sau đó thêm tiếp $1$ ml dung dịch glucozơ 1%, đun nóng nhẹ ống nghiệm.",
                    statements: [
                        TrueFalseStatement(id: "a", statement: "Sau thí nghiệm thấy một lớp kim loại màu sáng bóng bám vào thành ống nghiệm.", isCorrectTrue: true, explanation: "Bạc ($Ag$) kim loại sinh ra bám vào thành ống nghiệm."),
                        TrueFalseStatement(id: "b", statement: "Trong phản ứng trên, glucozơ đóng vai trò là chất oxi hóa.", isCorrectTrue: false, explanation: "Glucozơ bị oxi hóa thành axit gluconic nên nó đóng vai trò là chất khử."),
                        TrueFalseStatement(id: "c", statement: "Phản ứng chứng minh trong phân tử glucozơ có nhóm chức anđehit (-CHO).", isCorrectTrue: true, explanation: "Nhóm -CHO có tính chất khử tạo kết tủa Ag sáng gương."),
                        TrueFalseStatement(id: "d", statement: "Nếu thay glucozơ bằng saccarozơ thì hiện tượng tráng bạc xảy ra tương tự.", isCorrectTrue: false, explanation: "Saccarozơ không có nhóm -CHO tự do nên không tham gia phản ứng tráng bạc.")
                    ]
                ))
                }
            }
            
            if saCount > 0 {
            
                for i in 1...saCount {
                saList.append(ShortAnswerQuestion(
                    id: i,
                    question: "Câu \(i): Cho 18 gam glucozơ ($C_6H_{12}O_6$, $M = 180$) phản ứng hoàn toàn với dung dịch $AgNO_3/NH_3$ dư. Khối lượng bạc ($Ag$, $M = 108$) tối đa thu được là bao nhiêu gam?",
                    acceptedAnswers: ["21.6", "21.6g"],
                    unit: "g",
                    explanation: "$n_{glucozo} = \\frac{18}{180} = 0.1$ mol. Một phân tử glucozơ tráng bạc tạo 2 nguyên tử Ag: $n_{Ag} = 2 \\times 0.1 = 0.2$ mol. Khối lượng $m_{Ag} = 0.2 \\times 108 = 21.6$ gam."
                ))
                }
            }
            
        default: // English, Biology, History, Geography, Literature
            let generalMC: [(q: String, opts: [String], ans: Int, exp: String)] = [
                (
                    "Đặc điểm cốt lõi của phương pháp học tập chủ động theo chương trình GDPT 2026 là gì?",
                    ["Tự nghiên cứu, thảo luận và vận dụng kiến thức vào thực tiễn", "Học vẹt định nghĩa và ghi nhớ máy móc", "Chỉ làm bài tập tính toán không cần lý thuyết", "Ghi chép thụ động từ bài giảng"],
                    0,
                    "Chương trình mới phát triển phẩm chất và năng lực, đề cao tính chủ động và thực hành thực tiễn."
                ),
                (
                    "Trong bộ gen người bình thường, số lượng nhiễm sắc thể trong tế bào sinh dưỡng (2n) là:",
                    ["46 chiếc (23 cặp)", "48 chiếc (24 cặp)", "44 chiếc (22 cặp)", "23 chiếc"],
                    0,
                    "Bộ nhiễm sắc thể lưỡng bội của loài người là $2n = 46$, gồm 22 cặp NST thường và 1 cặp NST giới tính."
                ),
                (
                    "Địa hình nước ta có đặc điểm cơ bản nào sau đây?",
                    ["Đồi núi chiếm 3/4 diện tích lãnh thổ", "Đồng bằng chiếm 3/4 diện tích lãnh thổ", "Chủ yếu là địa hình cao nguyên hiểm trở", "Không chịu tác động của con người"],
                    0,
                    "Đặc điểm chung của địa hình Việt Nam là đồi núi chiếm 3/4 diện tích lãnh thổ, nhưng chủ yếu là đồi núi thấp."
                ),
                (
                    "Cách mạng tháng Tám năm 1945 của Việt Nam thành công đã dẫn tới sự kiện lịch sử trọng đại nào sau đó?",
                    ["Chủ tịch Hồ Chí Minh đọc Tuyên ngôn Độc lập khai sinh nước VNDCCH", "Chiến thắng Điện Biên Phủ lịch sử", "Ký kết Hiệp định Giơ-ne-vơ", "Thành lập Mặt trận Việt Minh"],
                    0,
                    "Ngày 2/9/1945 tại Quảng trường Ba Đình, Bác Hồ đọc Tuyên ngôn Độc lập thành lập nước VNDCCH."
                )
            ]
            
            if mcCount > 0 {
            
                for i in 1...mcCount {
                let item = generalMC[(i - 1) % generalMC.count]
                mcList.append(MultipleChoiceQuestion(
                    id: i,
                    question: "Câu \(i): \(item.q)",
                    options: item.opts,
                    correctIndex: item.ans,
                    explanation: item.exp
                ))
                }
            }
            
            if tfCount > 0 {
            
                for i in 1...tfCount {
                tfList.append(TrueFalseQuestion(
                    id: i,
                    context: "Dựa vào chuẩn kiến thức chuyên đề '\(topicDisplay)' môn \(subject) Lớp \(grade):",
                    statements: [
                        TrueFalseStatement(id: "a", statement: "Khái niệm nền tảng tuân thủ đầy đủ quy chuẩn sách giáo khoa mới của Bộ GD&ĐT.", isCorrectTrue: true, explanation: "Bám sát định hướng phát triển năng lực của Bộ GD&ĐT."),
                        TrueFalseStatement(id: "b", statement: "Phương pháp giải quyết vấn đề đòi hỏi kết hợp lý thuyết và tư duy phân tích thực tế.", isCorrectTrue: true, explanation: "Phù hợp với dạng câu hỏi kiểm tra năng lực hiện đại."),
                        TrueFalseStatement(id: "c", statement: "Kiến thức chỉ có giá trị lý thuyết hàn lâm, không thể ứng dụng trong đời sống.", isCorrectTrue: false, explanation: "Mọi chuyên đề trong chương trình mới đều gắn liền với thực tiễn."),
                        TrueFalseStatement(id: "d", statement: "Nội dung học tập này được tích hợp xuyên suốt các cấp học.", isCorrectTrue: true, explanation: "Đảm bảo tính liên thông và nâng cao theo chuẩn đổi mới.")
                    ]
                ))
                }
            }
            
            if saCount > 0 {
            
                for i in 1...saCount {
                saList.append(ShortAnswerQuestion(
                    id: i,
                    question: "Câu \(i): Số lượng nhiễm sắc thể trong bộ lưỡng bội (2n) của người bình thường là bao nhiêu?",
                    acceptedAnswers: ["46", "46 chiếc", "23 cặp"],
                    unit: "chiếc",
                    explanation: "Bộ NST của người gồm 46 chiếc, tạo thành 23 cặp."
                ))
                }
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
