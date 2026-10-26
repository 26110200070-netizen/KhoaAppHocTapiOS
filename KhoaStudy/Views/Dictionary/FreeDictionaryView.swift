import SwiftUI
import AVFoundation

struct FreeDictionaryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var service = FreeDictionaryService.shared
    
    @State private var searchInput: String = "technology"
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            // Pure clean reading surface - NO nested cards
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Navigation Top Bar (Flat, minimal)
                topNavigationBar
                
                // 2. Search Input Field & Quick Chips (Flat)
                searchHeaderSection
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 6)
                
                Divider()
                    .padding(.top, 4)
                
                // 3. Main Content (Typographic flow, NO boxes)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        if service.isLoading {
                            loadingStateView
                        } else if let error = service.errorMessage {
                            errorStateView(message: error)
                        } else if let result = service.currentResult {
                            dictionaryResultView(result: result)
                        } else {
                            initialWelcomeView
                        }
                        
                        Spacer().frame(height: 50)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
                }
            }
        }
        .onAppear {
            if service.currentResult == nil {
                Task {
                    await service.search(word: searchInput)
                }
            }
        }
    }
    
    // MARK: - 1. Top Navigation Bar (Flat, borderless)
    private var topNavigationBar: some View {
        HStack(spacing: 12) {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Trang Chủ")
                        .font(.system(size: 16, weight: .regular))
                }
                .foregroundColor(Color(hex: "#059669"))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 1) {
                Text("Từ Điển Tra Cứu")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("Free Dictionary API • Wiktionary")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(hex: "#6B7280"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }
    
    // MARK: - 2. Search Header Section (Flat, single-layer)
    private var searchHeaderSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                    
                    TextField("Nhập từ tiếng Anh cần tra...", text: $searchInput)
                        .font(.system(size: 15))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isInputFocused)
                        .onSubmit {
                            performSearch()
                        }
                    
                    if !searchInput.isEmpty {
                        Button(action: {
                            searchInput = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 15))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(Color(hex: "#F3F4F6"))
                .cornerRadius(10)
                
                Button(action: {
                    performSearch()
                }) {
                    Text("Tra từ")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .frame(height: 38)
                        .background(Color(hex: "#059669"))
                        .cornerRadius(10)
                }
            }
            
            // Quick Suggestion Chips (Minimal inline text)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Text("Gợi ý:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                    
                    ForEach(service.recentSearches, id: \.self) { word in
                        Button(action: {
                            searchInput = word
                            performSearch()
                        }) {
                            Text(word)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(hex: "#059669"))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    private func performSearch() {
        isInputFocused = false
        Task {
            await service.search(word: searchInput)
        }
    }
    
    // MARK: - 3. Loading State View (No boxes)
    private var loadingStateView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .tint(Color(hex: "#059669"))
                .scaleEffect(1.1)
                .padding(.top, 40)
            
            Text("Đang tra cứu từ điển...")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#6B7280"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - 4. Error State View (No boxes)
    private func errorStateView(message: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Không tìm thấy kết quả")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            
            Text(service.cleanText(message))
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#6B7280"))
            
            Button(action: {
                searchInput = "technology"
                performSearch()
            }) {
                Text("Thử tra từ: technology")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#059669"))
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
    }
    
    // MARK: - 5. Initial Welcome View (No boxes)
    private var initialWelcomeView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tra cứu từ điển Wiktionary")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            
            Text("Hơn 8.5 triệu từ vựng trực tiếp từ Free Dictionary API. Có phiên âm IPA chuẩn, nghĩa tiếng Việt, dạng từ và ví dụ câu thực tế.")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#4B5563"))
                .lineSpacing(4)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - 6. Dictionary Result View (Pure Typographic, Zero Boxes)
    private func dictionaryResultView(result: FreeDictionaryResponse) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Word Title & Pronunciation Header
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(result.word)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    // Audio Speak Button
                    Button(action: {
                        service.speak(text: result.word)
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#059669"))
                            .padding(6)
                    }
                }
                
                // IPA Phonetic Text
                if let pronList = result.entries?.compactMap({ $0.pronunciations }).flatMap({ $0 }), !pronList.isEmpty {
                    let ipaText = pronList.first(where: { $0.type == "ipa" })?.text ?? pronList.first?.text ?? ""
                    if !ipaText.isEmpty {
                        Text(ipaText)
                            .font(.system(size: 17, weight: .regular, design: .serif))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                }
                
                // Main Vietnamese Meaning (if available)
                if let meaning = service.wordVietnameseMeaning, !meaning.isEmpty {
                    Text(meaning)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#059669"))
                        .padding(.top, 2)
                }
                
                // Forms (Plural, Past, Participle, etc.)
                let allForms = result.entries?.compactMap({ $0.forms }).flatMap({ $0 }) ?? []
                if !allForms.isEmpty {
                    let formsStr = allForms.compactMap { f -> String? in
                        guard let w = f.word, !w.isEmpty else { return nil }
                        if let tag = f.tags?.first {
                            return "\(w) (\(tag))"
                        }
                        return w
                    }.prefix(5).joined(separator: ", ")
                    
                    if !formsStr.isEmpty {
                        Text("Các dạng từ: \(formsStr)")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(hex: "#6B7280"))
                            .padding(.top, 2)
                    }
                }
            }
            
            Divider()
            
            // Entries grouped by Part of Speech
            if let entries = result.entries, !entries.isEmpty {
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(entries) { entry in
                        entrySection(entry: entry)
                    }
                }
            }
            
            Divider()
            
            // Attribution
            if let src = result.source {
                attributionFooter(source: src)
            }
        }
    }
    
    // MARK: - Entry Section (Part of Speech & Definitions, NO BOXES)
    private func entrySection(entry: DictionaryEntry) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Part of Speech Header (e.g. DANH TỪ • NOUN)
            HStack(spacing: 6) {
                Text(entry.partOfSpeechVI.uppercased())
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: entry.posBadgeColorHex))
                
                if let posEN = entry.partOfSpeech {
                    Text("•  \(posEN.uppercased())")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
            }
            
            // Senses List (Pure Typography, NO nested boxes)
            if let senses = entry.senses, !senses.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(senses.enumerated()), id: \.offset) { index, sense in
                        VStack(alignment: .leading, spacing: 5) {
                            // 1. Definition in English
                            HStack(alignment: .top, spacing: 6) {
                                Text("\(index + 1).")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(hex: "#059669"))
                                
                                Text(sense.definition)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(hex: "#111827"))
                                    .lineSpacing(3)
                            }
                            
                            // 2. Meaning / Translation in Vietnamese (NO BOX, clean colored text)
                            let rawVi = service.vietnameseDefinitions[sense.definition] ?? sense.vietnameseTranslation
                            if let vi = rawVi, !vi.isEmpty {
                                let cleanVi = service.cleanText(vi)
                                if !cleanVi.isEmpty {
                                    HStack(alignment: .top, spacing: 4) {
                                        Text("→")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(hex: "#059669"))
                                        
                                        Text(cleanVi)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(Color(hex: "#059669"))
                                            .lineSpacing(2)
                                    }
                                    .padding(.leading, 20)
                                }
                            }
                            
                            // 3. Examples (Simple quote bullet, NO BOX)
                            if let examples = sense.examples, !examples.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(examples, id: \.self) { ex in
                                        HStack(alignment: .top, spacing: 6) {
                                            Text("•")
                                                .font(.system(size: 12))
                                                .foregroundColor(Color(hex: "#9CA3AF"))
                                            
                                            Text("\"\(ex)\"")
                                                .font(.system(size: 13, weight: .regular, design: .serif))
                                                .italic()
                                                .foregroundColor(Color(hex: "#4B5563"))
                                                .lineSpacing(2)
                                            
                                            Button(action: {
                                                service.speak(text: ex)
                                            }) {
                                                Image(systemName: "speaker.wave.1.fill")
                                                    .font(.system(size: 11))
                                                    .foregroundColor(Color(hex: "#9CA3AF"))
                                                    .padding(2)
                                            }
                                        }
                                    }
                                }
                                .padding(.leading, 20)
                                .padding(.top, 2)
                            }
                            
                            // 4. Synonyms & Antonyms (Inline plain text, NO pill boxes)
                            if let syns = sense.synonyms, !syns.isEmpty {
                                let synsStr = syns.prefix(5).joined(separator: ", ")
                                Text("Đồng nghĩa: \(synsStr)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#6B7280"))
                                    .padding(.leading, 20)
                                    .padding(.top, 1)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Attribution Footer (Flat text)
    private func attributionFooter(source: DictionarySource) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Dữ liệu từ English Wiktionary (giấy phép CC BY-SA 4.0) qua FreeDictionaryAPI.com.")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#9CA3AF"))
            
            if let urlStr = source.url, let url = URL(string: urlStr) {
                Link("Xem trang gốc trên Wiktionary", destination: url)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(hex: "#059669"))
            }
        }
        .padding(.top, 4)
    }
}
