import SwiftUI
import AVFoundation

enum EnglishLearningTab: Int, CaseIterable {
    case vocabulary = 0
    case translation = 1
    
    var title: String {
        switch self {
        case .vocabulary: return "Tra Từ Vựng"
        case .translation: return "Dịch Thuật AI"
        }
    }
    
    var icon: String {
        switch self {
        case .vocabulary: return "character.book.closed.fill"
        case .translation: return "arrow.left.arrow.right"
        }
    }
}

struct EnglishLearningView: View {
    @ObservedObject private var vocabStore = EnglishVocabularyStore.shared
    @ObservedObject private var translationService = EnglishTranslationService.shared
    
    @State private var currentTab: EnglishLearningTab = .vocabulary
    
    // Search & Filter States
    @State private var searchQuery: String = ""
    @State private var selectedCategory: VocabCategory = .all
    @State private var selectedLevel: CEFRLevel? = nil
    @State private var showingCategorySheet: Bool = false
    @State private var showingLevelSheet: Bool = false
    @State private var selectedWordDetail: EnglishWord? = nil
    
    // Translation States
    @State private var translationDirection: TranslationDirection = .enToVi
    @State private var inputText: String = ""
    @State private var translatedResult: TranslationResult? = nil
    @State private var hasCopied: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#F9FAFB")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Static Top Hero Bar with Banner
                headerSection
                
                // 2. Segment Switcher (Tra Từ Vựng vs Dịch Thuật AI)
                tabSegmentBar
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 12)
                
                // 3. Tab Content
                if currentTab == .vocabulary {
                    vocabularyView
                } else {
                    translationView
                }
            }
        }
        .sheet(item: $selectedWordDetail) { word in
            EnglishWordDetailSheet(word: word) {
                selectedWordDetail = nil
            }
        }
        .sheet(isPresented: $showingCategorySheet) {
            categorySelectionSheet
        }
        .sheet(isPresented: $showingLevelSheet) {
            levelSelectionSheet
        }
    }
    
    // MARK: - 1. Header Section
    private var headerSection: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                // Banner image
                Image("BannerEnglish")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 125)
                    .clipped()
                
                // Subtle gradient overlay for contrast
                LinearGradient(
                    colors: [Color.black.opacity(0.1), Color.black.opacity(0.65)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Header Titles
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Image(systemName: "globe.americas.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "#34D399"))
                        
                        Text("ENGLISH MASTERY • SHIMY AI")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#34D399"))
                            .kerning(0.8)
                    }
                    
                    Text("Học Tiếng Anh Thông Minh")
                        .font(.system(size: 21, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Từ vựng CEFR A1-C2 chuẩn Cambridge & Dịch thuật ngữ cảnh")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.85))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - 2. Segment Switcher
    private var tabSegmentBar: some View {
        HStack(spacing: 6) {
            ForEach(EnglishLearningTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        currentTab = tab
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 13, weight: .semibold))
                        
                        Text(tab.title)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(currentTab == tab ? .white : Color(hex: "#4B5563"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(
                        currentTab == tab ?
                        LinearGradient(colors: [Color(hex: "#059669"), Color(hex: "#047857")], startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(colors: [Color.white, Color.white], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(currentTab == tab ? Color.clear : Color.black.opacity(0.06), lineWidth: 1)
                    )
                    .shadow(color: currentTab == tab ? Color(hex: "#059669").opacity(0.25) : Color.clear, radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - 3. Vocabulary Tab View
    private var vocabularyView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                // Search & Live Autocomplete Bar
                searchBarWithAutocomplete
                
                // Dropdown selectors for Category & CEFR Level
                filterSelectorsRow
                
                // Word Count & Reset Filter
                wordCountHeader
                
                // Words Feed
                let words = vocabStore.filterWords(
                    category: selectedCategory,
                    level: selectedLevel,
                    searchQuery: searchQuery
                )
                
                if words.isEmpty {
                    emptyWordsState
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(words) { word in
                            wordCardRow(word: word)
                        }
                    }
                }
                
                Spacer().frame(height: 100)
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Search Bar with Live AI Suggestions
    private var searchBarWithAutocomplete: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                
                TextField("Nhập từ tiếng Anh hoặc tiếng Việt...", text: $searchQuery)
                    .font(.system(size: 14))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !searchQuery.isEmpty {
                    Button(action: {
                        searchQuery = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#9CA3AF"))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
            
            // Live Autocomplete Suggestions Dropdown
            let suggestions = vocabStore.getSuggestions(query: searchQuery)
            if !searchQuery.isEmpty && !suggestions.isEmpty {
                VStack(spacing: 0) {
                    HStack {
                        Text("Gợi ý từ Shimy AI:")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "#059669"))
                        Spacer()
                        Text("\(suggestions.count) gợi ý")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#9CA3AF"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#F0FDF4"))
                    
                    ForEach(suggestions) { sugg in
                        Button(action: {
                            selectedWordDetail = sugg
                        }) {
                            HStack(spacing: 8) {
                                Text(sugg.word)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "#111827"))
                                
                                Text(sugg.phonetic)
                                    .font(.system(size: 12, design: .serif))
                                    .foregroundColor(Color(hex: "#6B7280"))
                                
                                Spacer()
                                
                                Text(sugg.meaningVI)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#059669"))
                                    .lineLimit(1)
                                
                                Button(action: {
                                    vocabStore.speak(text: sugg.word)
                                }) {
                                    Image(systemName: "speaker.wave.1.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "#2563EB"))
                                        .padding(4)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                        }
                        .buttonStyle(.plain)
                        
                        Divider().background(Color(hex: "#F3F4F6"))
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Dropdown Selectors for Category & CEFR Level
    private var filterSelectorsRow: some View {
        HStack(spacing: 8) {
            // 1. Category Dropdown Button
            Button(action: {
                showingCategorySheet = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: selectedCategory.icon)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#059669"))
                    
                    Text(selectedCategory.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#1F2937"))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                .padding(.horizontal, 10)
                .frame(height: 38)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.07), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            
            // 2. CEFR Level Dropdown Button
            Button(action: {
                showingLevelSheet = true
            }) {
                HStack(spacing: 6) {
                    if let level = selectedLevel {
                        Text(level.rawValue)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: level.badgeColorHex))
                            .cornerRadius(6)
                        
                        Text(level.titleVI)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "#1F2937"))
                            .lineLimit(1)
                    } else {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#2563EB"))
                        
                        Text("Tất cả cấp độ")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "#1F2937"))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                .padding(.horizontal, 10)
                .frame(height: 38)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.07), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Word Count & Quick Reset
    private var wordCountHeader: some View {
        HStack {
            let count = vocabStore.filterWords(category: selectedCategory, level: selectedLevel, searchQuery: searchQuery).count
            Text("\(count) từ vựng được tìm thấy")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "#6B7280"))
            
            Spacer()
            
            if selectedCategory != .all || selectedLevel != nil || !searchQuery.isEmpty {
                Button(action: {
                    selectedCategory = .all
                    selectedLevel = nil
                    searchQuery = ""
                }) {
                    Text("Đặt lại bộ lọc")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#EF4444"))
                }
            }
        }
        .padding(.horizontal, 2)
        .padding(.vertical, 2)
    }
    
    // MARK: - Word Card Row
    private func wordCardRow(word: EnglishWord) -> some View {
        Button(action: {
            selectedWordDetail = word
        }) {
            HStack(alignment: .top, spacing: 12) {
                // Audio Speak Button
                Button(action: {
                    vocabStore.speak(text: word.word)
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#ECFDF5"))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#059669"))
                    }
                }
                .buttonStyle(.plain)
                
                // Word info
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(word.word)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        // Level Badge
                        Text(word.level.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(hex: word.level.badgeColorHex))
                            .cornerRadius(5)
                        
                        Text(word.partOfSpeech)
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                    
                    Text(word.phonetic)
                        .font(.system(size: 13, weight: .regular, design: .serif))
                        .foregroundColor(Color(hex: "#4B5563"))
                    
                    Text(word.meaningVI)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "#0F3E36"))
                        .lineLimit(2)
                        .padding(.top, 1)
                }
                
                Spacer()
                
                // Chevron indicator
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "#D1D5DB"))
                    .padding(.top, 12)
            }
            .padding(14)
            .background(Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Empty Words State
    private var emptyWordsState: some View {
        VStack(spacing: 12) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "#D1D5DB"))
                .padding(.top, 30)
            
            Text("Không tìm thấy từ vựng phù hợp")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "#4B5563"))
            
            Text("Hãy thử đổi từ khóa tìm kiếm hoặc chọn chủ đề/cấp độ khác.")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#9CA3AF"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    
    // MARK: - 4. Translation Tab View (Dịch thuật AI song ngữ)
    private var translationView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                // Language Direction Switcher Bar
                translationDirectionBar
                
                // Source Input Card
                sourceInputCard
                
                // Translate Action Button
                translateActionButton
                
                // Translation Result Card
                if translationService.isTranslating {
                    translatingLoadingCard
                } else if let result = translatedResult {
                    translatedOutputCard(result: result)
                }
                
                Spacer().frame(height: 100)
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Translation Direction Bar
    private var translationDirectionBar: some View {
        HStack {
            Text(translationDirection.sourceTitle)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#0F3E36"))
                .frame(maxWidth: .infinity)
            
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    translationDirection = (translationDirection == .enToVi) ? .viToEn : .enToVi
                    // Swap text if translation exists
                    if let res = translatedResult, !res.translatedText.isEmpty {
                        let oldInput = inputText
                        inputText = res.translatedText
                        translatedResult = TranslationResult(
                            translatedText: oldInput,
                            keyPhrases: res.keyPhrases,
                            grammarNotes: res.grammarNotes
                        )
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#ECFDF5"))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "#059669"))
                }
            }
            .buttonStyle(.plain)
            
            Text(translationDirection.targetTitle)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "#0F3E36"))
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - Source Input Card
    private var sourceInputCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(translationDirection.sourceTitle)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                
                Spacer()
                
                if !inputText.isEmpty {
                    Button(action: {
                        inputText = ""
                        translatedResult = nil
                    }) {
                        Text("Xóa hết")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#EF4444"))
                    }
                } else {
                    Button(action: {
                        if let clipboard = UIPasteboard.general.string {
                            inputText = clipboard
                            triggerTranslation()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.clipboard")
                                .font(.system(size: 11))
                            Text("Dán")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(Color(hex: "#059669"))
                    }
                }
            }
            
            TextEditor(text: $inputText)
                .frame(minHeight: 100)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#111827"))
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .onChange(of: inputText) { newValue in
                    translationService.debounceTranslate(text: newValue, direction: translationDirection) { result in
                        self.translatedResult = result
                    }
                }
            
            HStack {
                if !inputText.isEmpty {
                    Button(action: {
                        let lang = (translationDirection == .enToVi) ? "en-US" : "vi-VN"
                        vocabStore.speak(text: inputText, languageCode: lang)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 12))
                            Text("Nghe câu")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(Color(hex: "#4B5563"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#F3F4F6"))
                        .cornerRadius(6)
                    }
                }
                
                Spacer()
                
                Text("\(inputText.count) ký tự")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 1)
    }
    
    // MARK: - Translate Action Button
    private var translateActionButton: some View {
        Button(action: {
            triggerTranslation()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .bold))
                
                Text("Dịch Chính Xác Ngay")
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                LinearGradient(colors: [Color(hex: "#059669"), Color(hex: "#047857")], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(12)
            .shadow(color: Color(hex: "#059669").opacity(0.3), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
    
    private func triggerTranslation() {
        Task {
            await translationService.performTranslation(text: inputText, direction: translationDirection) { res in
                self.translatedResult = res
            }
        }
    }
    
    // MARK: - Translating Loading Card
    private var translatingLoadingCard: some View {
        HStack(spacing: 10) {
            ProgressView()
                .tint(Color(hex: "#059669"))
            Text("Shimy AI đang dịch và phân tích ngữ pháp...")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(hex: "#6B7280"))
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - Translated Output Card
    private func translatedOutputCard(result: TranslationResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "#059669"))
                    
                    Text("BẢN DỊCH CHUẨN XÁC")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#059669"))
                        .kerning(0.5)
                }
                
                Spacer()
                
                // Copy button
                Button(action: {
                    UIPasteboard.general.string = result.translatedText
                    hasCopied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        hasCopied = false
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: hasCopied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 11))
                        Text(hasCopied ? "Đã chép" : "Sao chép")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(hasCopied ? Color(hex: "#059669") : Color(hex: "#4B5563"))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#F3F4F6"))
                    .cornerRadius(6)
                }
            }
            
            // Translated Text
            Text(result.translatedText)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "#0F3E36"))
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Audio Speak Translated Text
            Button(action: {
                let targetLang = (translationDirection == .enToVi) ? "vi-VN" : "en-US"
                vocabStore.speak(text: result.translatedText, languageCode: targetLang)
            }) {
                HStack(spacing: 5) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 12))
                    Text("Phát âm bản dịch")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(Color(hex: "#2563EB"))
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(Color(hex: "#EFF6FF"))
                .cornerRadius(8)
            }
            
            // Grammar & Structure Notes
            if !result.grammarNotes.isEmpty {
                Divider()
                    .background(Color(hex: "#E5E7EB"))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("PHÂN TÍCH NGỮ PHÁP & THÌ CÂU")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                    
                    Text(result.grammarNotes)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(hex: "#4B5563"))
                        .lineSpacing(3)
                }
            }
            
            // Key Phrases Tags
            if !result.keyPhrases.isEmpty {
                Divider()
                    .background(Color(hex: "#E5E7EB"))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("TỪ KHÓA QUAN TRỌNG")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                    
                    HStack(spacing: 6) {
                        ForEach(result.keyPhrases, id: \.self) { phrase in
                            Text(phrase)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color(hex: "#7C3AED"))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color(hex: "#F5F3FF"))
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#059669").opacity(0.18), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
    
    // MARK: - Category Selection Popup Sheet
    private var categorySelectionSheet: some View {
        NavigationView {
            List {
                ForEach(VocabCategory.allCases) { cat in
                    Button(action: {
                        selectedCategory = cat
                        showingCategorySheet = false
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: cat.icon)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(selectedCategory == cat ? Color(hex: "#059669") : Color(hex: "#6B7280"))
                                .frame(width: 24)
                            
                            Text(cat.rawValue)
                                .font(.system(size: 15, weight: selectedCategory == cat ? .bold : .regular))
                                .foregroundColor(selectedCategory == cat ? Color(hex: "#059669") : Color(hex: "#111827"))
                            
                            Spacer()
                            
                            if selectedCategory == cat {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "#059669"))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Chọn Chủ Đề Từ Vựng")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Xong") {
                        showingCategorySheet = false
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
                }
            }
        }
    }
    
    // MARK: - CEFR Level Selection Popup Sheet
    private var levelSelectionSheet: some View {
        NavigationView {
            List {
                // All levels option
                Button(action: {
                    selectedLevel = nil
                    showingLevelSheet = false
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "square.grid.2x2.fill")
                            .foregroundColor(selectedLevel == nil ? Color(hex: "#059669") : Color(hex: "#6B7280"))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tất cả cấp độ")
                                .font(.system(size: 15, weight: selectedLevel == nil ? .bold : .regular))
                                .foregroundColor(selectedLevel == nil ? Color(hex: "#059669") : Color(hex: "#111827"))
                            Text("Xem toàn bộ từ vựng từ A1 đến C2")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                        }
                        
                        Spacer()
                        
                        if selectedLevel == nil {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "#059669"))
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // Specific CEFR Levels
                ForEach(CEFRLevel.allCases) { lvl in
                    Button(action: {
                        selectedLevel = lvl
                        showingLevelSheet = false
                    }) {
                        HStack(alignment: .top, spacing: 12) {
                            Text(lvl.rawValue)
                                .font(.system(size: 12, weight: .heavy))
                                .foregroundColor(.white)
                                .frame(width: 34, height: 26)
                                .background(Color(hex: lvl.badgeColorHex))
                                .cornerRadius(6)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text("\(lvl.titleEN) – \(lvl.titleVI)")
                                        .font(.system(size: 15, weight: selectedLevel == lvl ? .bold : .semibold))
                                        .foregroundColor(selectedLevel == lvl ? Color(hex: "#059669") : Color(hex: "#111827"))
                                }
                                
                                Text(lvl.description)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#6B7280"))
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            if selectedLevel == lvl {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "#059669"))
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Chọn Cấp Độ CEFR")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Xong") {
                        showingLevelSheet = false
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "#059669"))
                }
            }
        }
    }
}
