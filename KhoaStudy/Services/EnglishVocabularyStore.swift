import Foundation
import AVFoundation

class EnglishVocabularyStore: ObservableObject {
    static let shared = EnglishVocabularyStore()
    
    // Built-in speech synthesizer
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    @Published var allWords: [EnglishWord] = []
    
    init() {
        self.allWords = EnglishVocabularyStore.buildDefaultVocabulary()
    }
    
    // MARK: - Native Speech Pronunciation
    func speak(text: String, languageCode: String = "en-US") {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode) ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.46 // Clear learning pace
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        // Ensure audio session doesn't fail silently
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        
        speechSynthesizer.speak(utterance)
    }
    
    // MARK: - Autocomplete & Live Search Suggestions
    func getSuggestions(query: String, limit: Int = 8) -> [EnglishWord] {
        let clean = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !clean.isEmpty else { return [] }
        
        // Priority 1: Words starting with query
        let prefixMatches = allWords.filter { $0.word.lowercased().hasPrefix(clean) }
        
        // Priority 2: Meaning in Vietnamese starting with query
        let meaningPrefix = allWords.filter {
            !prefixMatches.contains($0) && $0.meaningVI.lowercased().contains(clean)
        }
        
        // Priority 3: Words containing query
        let containsMatches = allWords.filter {
            !prefixMatches.contains($0) && !meaningPrefix.contains($0) && $0.word.lowercased().contains(clean)
        }
        
        let combined = prefixMatches + meaningPrefix + containsMatches
        return Array(combined.prefix(limit))
    }
    
    // MARK: - Filter Words by Category and CEFR Level
    func filterWords(category: VocabCategory, level: CEFRLevel?, searchQuery: String) -> [EnglishWord] {
        var results = allWords
        
        if category != .all {
            results = results.filter { $0.category == category }
        }
        
        if let level = level {
            results = results.filter { $0.level == level }
        }
        
        let cleanQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !cleanQuery.isEmpty {
            results = results.filter {
                $0.word.lowercased().contains(cleanQuery) ||
                $0.meaningVI.lowercased().contains(cleanQuery) ||
                $0.phonetic.lowercased().contains(cleanQuery)
            }
        }
        
        return results
    }
    
    // MARK: - Curated Rich Vocabulary Data
    static func buildDefaultVocabulary() -> [EnglishWord] {
        return [
            // ================= A1 BEGINNER =================
            EnglishWord(
                word: "Family",
                phonetic: "/ˈfæm.əl.i/",
                partOfSpeech: "n.",
                meaningVI: "Gia đình, tổ ấm",
                category: .family,
                level: .a1,
                collocations: ["family member", "close family", "family values"],
                examples: [
                    WordExample(sentenceEN: "I spend every Sunday having dinner with my family.", sentenceVI: "Tôi dành mỗi ngày Chủ Nhật để ăn tối cùng gia đình mình."),
                    WordExample(sentenceEN: "She comes from a large family with five siblings.", sentenceVI: "Cô ấy xuất thân từ một gia đình lớn có năm anh chị em.")
                ]
            ),
            EnglishWord(
                word: "Parents",
                phonetic: "/ˈpeə.rənts/",
                partOfSpeech: "n.",
                meaningVI: "Bố mẹ, phụ huynh",
                category: .family,
                level: .a1,
                collocations: ["live with parents", "proud parents", "foster parents"],
                examples: [
                    WordExample(sentenceEN: "My parents always support my educational goals.", sentenceVI: "Bố mẹ tôi luôn ủng hộ các mục tiêu học tập của tôi.")
                ]
            ),
            EnglishWord(
                word: "School",
                phonetic: "/skuːl/",
                partOfSpeech: "n.",
                meaningVI: "Trường học",
                category: .education,
                level: .a1,
                collocations: ["go to school", "high school", "school uniform"],
                examples: [
                    WordExample(sentenceEN: "We walk to school together every morning.", sentenceVI: "Chúng tôi cùng nhau đi bộ đến trường mỗi buổi sáng.")
                ]
            ),
            EnglishWord(
                word: "Teacher",
                phonetic: "/ˈtiː.tʃər/",
                partOfSpeech: "n.",
                meaningVI: "Giáo viên, thầy cô",
                category: .education,
                level: .a1,
                collocations: ["homeroom teacher", "experienced teacher"],
                examples: [
                    WordExample(sentenceEN: "Our English teacher explains grammar very clearly.", sentenceVI: "Giáo viên tiếng Anh của chúng tôi giải thích ngữ pháp rất dễ hiểu.")
                ]
            ),
            EnglishWord(
                word: "Breakfast",
                phonetic: "/ˈbrek.fəst/",
                partOfSpeech: "n.",
                meaningVI: "Bữa ăn sáng",
                category: .food,
                level: .a1,
                collocations: ["have breakfast", "eat breakfast", "skip breakfast"],
                examples: [
                    WordExample(sentenceEN: "Eating breakfast provides energy for the whole day.", sentenceVI: "Ăn bữa sáng cung cấp năng lượng cho cả ngày.")
                ]
            ),
            EnglishWord(
                word: "Water",
                phonetic: "/ˈwɔː.tər/",
                partOfSpeech: "n.",
                meaningVI: "Nước uống",
                category: .dining,
                level: .a1,
                collocations: ["drink water", "mineral water", "glass of water"],
                examples: [
                    WordExample(sentenceEN: "Doctors advise drinking at least two liters of water daily.", sentenceVI: "Bác sĩ khuyên nên uống ít nhất hai lít nước mỗi ngày.")
                ]
            ),
            EnglishWord(
                word: "Happy",
                phonetic: "/ˈhæp.i/",
                partOfSpeech: "adj.",
                meaningVI: "Hạnh phúc, vui mừng",
                category: .emotions,
                level: .a1,
                collocations: ["feel happy", "happy about", "happy family"],
                examples: [
                    WordExample(sentenceEN: "The students were very happy with their exam results.", sentenceVI: "Các học sinh rất vui mừng với kết quả thi của mình.")
                ]
            ),
            EnglishWord(
                word: "Bus",
                phonetic: "/bʌs/",
                partOfSpeech: "n.",
                meaningVI: "Xe buýt",
                category: .transport,
                level: .a1,
                collocations: ["take the bus", "bus stop", "catch a bus"],
                examples: [
                    WordExample(sentenceEN: "I catch the bus number 08 to go to the city center.", sentenceVI: "Tôi bắt xe buýt số 08 để đi đến trung tâm thành phố.")
                ]
            ),
            
            // ================= A2 ELEMENTARY =================
            EnglishWord(
                word: "Discount",
                phonetic: "/ˈdɪs.kaʊnt/",
                partOfSpeech: "n.",
                meaningVI: "Khoản giảm giá, chiết khấu",
                category: .shopping,
                level: .a2,
                collocations: ["get a discount", "special discount", "student discount"],
                examples: [
                    WordExample(sentenceEN: "Students receive a 20% discount on textbooks.", sentenceVI: "Học sinh được giảm giá 20% khi mua sách giáo khoa.")
                ]
            ),
            EnglishWord(
                word: "Receipt",
                phonetic: "/rɪˈsiːt/",
                partOfSpeech: "n.",
                meaningVI: "Hóa đơn, biên lai mua hàng",
                category: .shopping,
                level: .a2,
                collocations: ["keep the receipt", "cashier receipt"],
                examples: [
                    WordExample(sentenceEN: "Please keep your receipt in case you want to exchange the shirt.", sentenceVI: "Vui lòng giữ lại hóa đơn trong trường hợp bạn muốn đổi áo.")
                ]
            ),
            EnglishWord(
                word: "Luggage",
                phonetic: "/ˈlʌɡ.ɪdʒ/",
                partOfSpeech: "n.",
                meaningVI: "Hành lý du lịch",
                category: .travel,
                level: .a2,
                collocations: ["pack luggage", "hand luggage", "excess luggage"],
                examples: [
                    WordExample(sentenceEN: "You should weigh your luggage before going to the airport.", sentenceVI: "Bạn nên cân hành lý trước khi đến sân bay.")
                ]
            ),
            EnglishWord(
                word: "Medicine",
                phonetic: "/ˈmed.ɪ.sən/",
                partOfSpeech: "n.",
                meaningVI: "Thuốc uống, y khoa",
                category: .health,
                level: .a2,
                collocations: ["take medicine", "prescribe medicine"],
                examples: [
                    WordExample(sentenceEN: "Take this medicine three times a day after meals.", sentenceVI: "Uống thuốc này ba lần một ngày sau bữa ăn.")
                ]
            ),
            EnglishWord(
                word: "Smartphone",
                phonetic: "/ˈsmɑːt.fəʊn/",
                partOfSpeech: "n.",
                meaningVI: "Điện thoại thông minh",
                category: .devices,
                level: .a2,
                collocations: ["use a smartphone", "smartphone screen"],
                examples: [
                    WordExample(sentenceEN: "A smartphone is useful for searching vocabulary quickly.", sentenceVI: "Điện thoại thông minh rất hữu ích để tra từ vựng nhanh chóng.")
                ]
            ),
            EnglishWord(
                word: "Routine",
                phonetic: "/ruːˈtiːn/",
                partOfSpeech: "n.",
                meaningVI: "Thói quen, lịch trình hằng ngày",
                category: .dailyLife,
                level: .a2,
                collocations: ["daily routine", "morning routine", "break the routine"],
                examples: [
                    WordExample(sentenceEN: "Having a stable morning routine increases productivity.", sentenceVI: "Có một thói quen buổi sáng ổn định giúp tăng năng suất làm việc.")
                ]
            ),
            
            // ================= B1 INTERMEDIATE =================
            EnglishWord(
                word: "Experience",
                phonetic: "/ɪkˈspɪə.ri.əns/",
                partOfSpeech: "n. / v.",
                meaningVI: "Trải nghiệm, kinh nghiệm thực tế",
                category: .dailyLife,
                level: .b1,
                collocations: ["gain experience", "practical experience", "memorable experience"],
                examples: [
                    WordExample(sentenceEN: "Studying abroad was an unforgettable experience for him.", sentenceVI: "Du học là một trải nghiệm khó quên đối với anh ấy."),
                    WordExample(sentenceEN: "Volunteering helps young people gain valuable social experience.", sentenceVI: "Hoạt động tình nguyện giúp thanh niên có thêm kinh nghiệm xã hội quý giá.")
                ]
            ),
            EnglishWord(
                word: "Anxious",
                phonetic: "/ˈæŋk.ʃəs/",
                partOfSpeech: "adj.",
                meaningVI: "Lo âu, bồn chồn, hồi hộp",
                category: .emotions,
                level: .b1,
                collocations: ["feel anxious about", "anxious moments"],
                examples: [
                    WordExample(sentenceEN: "Many students feel anxious right before major examinations.", sentenceVI: "Nhiều học sinh cảm thấy lo âu ngay trước các kỳ thi lớn.")
                ]
            ),
            EnglishWord(
                word: "Communicate",
                phonetic: "/kəˈmjuː.nɪ.keɪt/",
                partOfSpeech: "v.",
                meaningVI: "Giao tiếp, truyền đạt thông điệp",
                category: .communication,
                level: .b1,
                collocations: ["communicate effectively", "communicate with others"],
                examples: [
                    WordExample(sentenceEN: "Learning English helps you communicate with people all over the world.", sentenceVI: "Học tiếng Anh giúp bạn giao tiếp với mọi người trên toàn thế giới.")
                ]
            ),
            EnglishWord(
                word: "Requirement",
                phonetic: "/rɪˈkwaɪə.mənt/",
                partOfSpeech: "n.",
                meaningVI: "Yêu cầu, điều kiện tiên quyết",
                category: .needs,
                level: .b1,
                collocations: ["meet requirements", "basic requirement", "admission requirement"],
                examples: [
                    WordExample(sentenceEN: "Fluency in English is an essential requirement for this job.", sentenceVI: "Thông thạo tiếng Anh là một yêu cầu thiết yếu cho công việc này.")
                ]
            ),
            EnglishWord(
                word: "Application",
                phonetic: "/ˌæp.lɪˈkeɪ.ʃən/",
                partOfSpeech: "n.",
                meaningVI: "Ứng dụng phần mềm, đơn ứng tuyển",
                category: .technology,
                level: .b1,
                collocations: ["mobile application", "job application", "practical application"],
                examples: [
                    WordExample(sentenceEN: "This application helps students memorize vocabulary systematically.", sentenceVI: "Ứng dụng này giúp học sinh ghi nhớ từ vựng một cách có hệ thống.")
                ]
            ),
            
            // ================= B2 UPPER-INTERMEDIATE =================
            EnglishWord(
                word: "Curriculum",
                phonetic: "/kəˈrɪk.jə.ləm/",
                partOfSpeech: "n.",
                meaningVI: "Khung chương trình giảng dạy",
                category: .education,
                level: .b2,
                collocations: ["national curriculum", "curriculum reform", "extracurricular"],
                examples: [
                    WordExample(sentenceEN: "The new national curriculum focuses on practical problem-solving skills.", sentenceVI: "Chương trình giáo dục quốc gia mới tập trung vào kỹ năng giải quyết vấn đề thực tế.")
                ]
            ),
            EnglishWord(
                word: "Innovation",
                phonetic: "/ˌɪn.əˈveɪ.ʃən/",
                partOfSpeech: "n.",
                meaningVI: "Sự đổi mới, sáng kiến cải tiến",
                category: .technology,
                level: .b2,
                collocations: ["technological innovation", "encourage innovation", "drive innovation"],
                examples: [
                    WordExample(sentenceEN: "Technological innovation has transformed modern language learning.", sentenceVI: "Sự đổi mới công nghệ đã làm thay đổi hoàn toàn cách học ngôn ngữ hiện đại.")
                ]
            ),
            EnglishWord(
                word: "Controversy",
                phonetic: "/ˈkɒn.trə.vɜː.si/",
                partOfSpeech: "n.",
                meaningVI: "Sự tranh cãi, luồng dư luận trái chiều",
                category: .communication,
                level: .b2,
                collocations: ["spark controversy", "cause controversy", "avoid controversy"],
                examples: [
                    WordExample(sentenceEN: "The new educational policy sparked considerable controversy in the media.", sentenceVI: "Chính sách giáo dục mới đã châm ngòi cho sự tranh cãi đáng kể trên truyền thông.")
                ]
            ),
            EnglishWord(
                word: "Nutritious",
                phonetic: "/njuːˈtrɪʃ.əs/",
                partOfSpeech: "adj.",
                meaningVI: "Bổ dưỡng, giàu chất dinh dưỡng",
                category: .food,
                level: .b2,
                collocations: ["nutritious food", "nutritious meal", "highly nutritious"],
                examples: [
                    WordExample(sentenceEN: "A nutritious diet enhances cognitive performance during exams.", sentenceVI: "Chế độ ăn bổ dưỡng giúp nâng cao hiệu suất nhận thức trong mùa thi cử.")
                ]
            ),
            
            // ================= C1 ADVANCED =================
            EnglishWord(
                word: "Ubiquitous",
                phonetic: "/juːˈbɪk.wɪ.təs/",
                partOfSpeech: "adj.",
                meaningVI: "Phổ biến khắp nơi, đâu đâu cũng thấy",
                category: .technology,
                level: .c1,
                collocations: ["ubiquitous presence", "ubiquitous computing"],
                examples: [
                    WordExample(sentenceEN: "Artificial intelligence has become ubiquitous in educational software.", sentenceVI: "Trí tuệ nhân tạo đã trở nên phổ biến khắp nơi trong các phần mềm giáo dục.")
                ]
            ),
            EnglishWord(
                word: "Comprehensive",
                phonetic: "/ˌkɒm.prɪˈhen.sɪv/",
                partOfSpeech: "adj.",
                meaningVI: "Toàn diện, bao quát mọi mặt",
                category: .education,
                level: .c1,
                collocations: ["comprehensive study", "comprehensive analysis", "comprehensive review"],
                examples: [
                    WordExample(sentenceEN: "The app offers a comprehensive approach to mastering CEFR levels.", sentenceVI: "Ứng dụng đem đến một phương pháp toàn diện để làm chủ các cấp độ CEFR.")
                ]
            ),
            EnglishWord(
                word: "Empathy",
                phonetic: "/ˈem.pə.θi/",
                partOfSpeech: "n.",
                meaningVI: "Sự thấu cảm, khả năng đồng cảm sâu sắc",
                category: .emotions,
                level: .c1,
                collocations: ["feel empathy for", "develop empathy", "demonstrate empathy"],
                examples: [
                    WordExample(sentenceEN: "Developing empathy is crucial for intercultural communication.", sentenceVI: "Phát triển sự thấu cảm là điều tối quan trọng trong giao tiếp liên văn hóa.")
                ]
            ),
            EnglishWord(
                word: "Sustainability",
                phonetic: "/səˌsteɪ.nəˈbɪl.ə.ti/",
                partOfSpeech: "n.",
                meaningVI: "Tính bền vững, sự phát triển lâu dài",
                category: .needs,
                level: .c1,
                collocations: ["environmental sustainability", "promote sustainability"],
                examples: [
                    WordExample(sentenceEN: "Modern transport systems must prioritize environmental sustainability.", sentenceVI: "Hệ thống giao thông hiện đại phải ưu tiên tính bền vững về mặt môi trường.")
                ]
            ),
            
            // ================= C2 PROFICIENCY =================
            EnglishWord(
                word: "Serendipity",
                phonetic: "/ˌser.ənˈdɪp.ə.ti/",
                partOfSpeech: "n.",
                meaningVI: "Sự tình cờ may mắn, duyên may",
                category: .dailyLife,
                level: .c2,
                collocations: ["pure serendipity", "moment of serendipity"],
                examples: [
                    WordExample(sentenceEN: "Discovering this study method was pure serendipity, yet it revolutionized my results.", sentenceVI: "Phát hiện ra phương pháp học này là một sự tình cờ may mắn, nhưng nó đã làm thay đổi hoàn toàn kết quả của tôi.")
                ]
            ),
            EnglishWord(
                word: "Ephemeral",
                phonetic: "/ɪˈfem.ər.əl/",
                partOfSpeech: "adj.",
                meaningVI: "Phù du, chóng tàn, ngắn ngủi",
                category: .emotions,
                level: .c2,
                collocations: ["ephemeral pleasure", "ephemeral nature of fashion"],
                examples: [
                    WordExample(sentenceEN: "Trends on social media are ephemeral, but fundamental knowledge endures.", sentenceVI: "Các xu hướng trên mạng xã hội chỉ là phù du ngắn ngủi, nhưng kiến thức nền tảng sẽ luôn trường tồn.")
                ]
            ),
            EnglishWord(
                word: "Eloquence",
                phonetic: "/ˈel.ə.kwəns/",
                partOfSpeech: "n.",
                meaningVI: "Tài hùng biện, sự diễn đạt lưu loát và thuyết phục",
                category: .communication,
                level: .c2,
                collocations: ["speak with eloquence", "persuasive eloquence"],
                examples: [
                    WordExample(sentenceEN: "Her eloquence in debate persuaded the entire academic committee.", sentenceVI: "Tài hùng biện của cô ấy trong buổi tranh biện đã thuyết phục toàn bộ hội đồng học thuật.")
                ]
            ),
            EnglishWord(
                word: "Quintessential",
                phonetic: "/ˌkwɪn.tɪˈsen.ʃəl/",
                partOfSpeech: "adj.",
                meaningVI: "Tinh túy, mẫu mực nhất, mang tính điển hình cao",
                category: .dining,
                level: .c2,
                collocations: ["quintessential dish", "quintessential example"],
                examples: [
                    WordExample(sentenceEN: "Pho is considered the quintessential dish of Vietnamese culinary culture.", sentenceVI: "Phở được xem là món ăn tinh túy điển hình của văn hóa ẩm thực Việt Nam.")
                ]
            )
        ]
    }
}
