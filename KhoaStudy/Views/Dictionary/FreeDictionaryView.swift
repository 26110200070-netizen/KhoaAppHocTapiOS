import SwiftUI
import AVFoundation

struct FreeDictionaryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var service = FreeDictionaryService.shared
    
    @State private var searchInput: String = "cause"
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#F8FAF9")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Navigation Top Bar
                topNavigationBar
                
                // 2. Search Input Field & Quick Chips
                searchHeaderSection
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                // 3. Main Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if service.isLoading {
                            loadingStateView
                        } else if let error = service.errorMessage {
                            errorStateView(message: error)
                        } else if let result = service.currentResult {
                            dictionaryResultView(result: result)
                        } else {
                            initialWelcomeView
                        }
                        
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
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
    
    // MARK: - 1. Top Navigation Bar
    private var topNavigationBar: some View {
        HStack(spacing: 12) {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                    Text("Trang Chủ")
                        .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(Color(hex: "#059669"))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(hex: "#ECFDF5"))
                .clipShape(Capsule())
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("Từ Điển Tra Cứu")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(hex: "#10B981"))
                        .frame(width: 6, height: 6)
                    Text("Free Dictionary API • 8.5M+ từ")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "#059669"))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.05)),
            alignment: .bottom
        )
    }
    
    // MARK: - 2. Search Header Section
    private var searchHeaderSection: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
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
                
                Button(action: {
                    performSearch()
                }) {
                    Text("Tra từ")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .frame(height: 42)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#059669"), Color(hex: "#047857")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color(hex: "#059669").opacity(0.25), radius: 4, x: 0, y: 2)
                }
            }
            
            // Quick Suggestion Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    Text("Gợi ý:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#6B7280"))
                    
                    ForEach(service.recentSearches, id: \.self) { word in
                        Button(action: {
                            searchInput = word
                            isInputFocused = false
                            Task {
                                await service.search(word: word)
                            }
                        }) {
                            Text(word)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#0F3E36"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private func performSearch() {
        isInputFocused = false
        Task {
            await service.search(word: searchInput)
        }
    }
    
    // MARK: - 3. Loading State View
    private var loadingStateView: some View {
        VStack(spacing: 14) {
            ProgressView()
                .tint(Color(hex: "#059669"))
                .scaleEffect(1.2)
                .padding(.top, 40)
            
            Text("Đang tra cứu Wiktionary...")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#6B7280"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - 4. Error State View
    private func errorStateView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 44))
                .foregroundColor(Color(hex: "#EF4444"))
                .padding(.top, 30)
            
            Text("Không tìm thấy kết quả")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            
            Text(message)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#6B7280"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button(action: {
                searchInput = "cause"
                performSearch()
            }) {
                Text("Thử tra từ mẫu: 'cause'")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "#059669"))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#ECFDF5"))
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - 5. Initial Welcome View
    private var initialWelcomeView: some View {
        VStack(spacing: 12) {
            Image(systemName: "character.book.closed.fill")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "#059669"))
                .padding(.top, 30)
            
            Text("Tra cứu hơn 8.5 Triệu từ vựng")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            
            Text("Dữ liệu trực tiếp từ English Wiktionary qua Free Dictionary API. Có phiên âm IPA chuẩn, nghĩa tiếng Việt, dạng từ và ví dụ câu thực tế.")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#6B7280"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - 6. Dictionary Result View
    private func dictionaryResultView(result: FreeDictionaryResponse) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Word Hero Header Card
            wordHeroHeaderCard(result: result)
            
            // Entries grouped by Part of Speech
            if let entries = result.entries, !entries.isEmpty {
                ForEach(entries) { entry in
                    entryCard(entry: entry)
                }
            }
            
            // Attribution
            if let src = result.source {
                attributionCard(source: src)
            }
        }
    }
    
    // MARK: - Word Hero Header Card
    private func wordHeroHeaderCard(result: FreeDictionaryResponse) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.word)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    // Pronunciations / IPA
                    if let pronList = result.entries?.compactMap({ $0.pronunciations }).flatMap({ $0 }), !pronList.isEmpty {
                        let ipaText = pronList.first(where: { $0.type == "ipa" })?.text ?? pronList.first?.text ?? ""
                        if !ipaText.isEmpty {
                            HStack(spacing: 8) {
                                Text(ipaText)
                                    .font(.system(size: 17, weight: .medium, design: .serif))
                                    .foregroundColor(Color(hex: "#4B5563"))
                                
                                Button(action: {
                                    service.speak(text: result.word)
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "speaker.wave.2.fill")
                                            .font(.system(size: 12, weight: .bold))
                                        Text("Phát âm")
                                            .font(.system(size: 12, weight: .semibold))
                                    }
                                    .foregroundColor(Color(hex: "#059669"))
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 4)
                                    .background(Color(hex: "#ECFDF5"))
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    } else {
                        Button(action: {
                            service.speak(text: result.word)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 12, weight: .bold))
                                Text("Phát âm")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(Color(hex: "#059669"))
                            .padding(.horizontal, 9)
                            .padding(.vertical, 4)
                            .background(Color(hex: "#ECFDF5"))
                            .clipShape(Capsule())
                        }
                    }
                }
                
                Spacer()
            }
            
            // Word Forms (Plural, Past, Participle, etc.)
            let allForms = result.entries?.compactMap({ $0.forms }).flatMap({ $0 }) ?? []
            if !allForms.isEmpty {
                Divider()
                    .background(Color(hex: "#E5E7EB"))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("CÁC DẠNG TỪ (FORMS)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(allForms.prefix(8))) { form in
                                if let w = form.word, !w.isEmpty {
                                    HStack(spacing: 4) {
                                        Text(w)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(Color(hex: "#1F2937"))
                                        
                                        if let tag = form.tags?.first {
                                            Text("(\(tag))")
                                                .font(.system(size: 10))
                                                .foregroundColor(Color(hex: "#6B7280"))
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(hex: "#F3F4F6"))
                                    .cornerRadius(6)
                                }
                            }
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
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
    }
    
    // MARK: - Entry Card (Part of Speech & Senses)
    private func entryCard(entry: DictionaryEntry) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Part of Speech Badge
            HStack(spacing: 8) {
                Text(entry.partOfSpeechVI.uppercased())
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: entry.posBadgeColorHex))
                    .cornerRadius(6)
                
                if let posEN = entry.partOfSpeech {
                    Text("(\(posEN.capitalized))")
                        .font(.system(size: 13, weight: .medium, design: .serif))
                        .foregroundColor(Color(hex: "#6B7280"))
                }
                
                Spacer()
            }
            
            // Senses List
            if let senses = entry.senses, !senses.isEmpty {
                VStack(spacing: 12) {
                    ForEach(Array(senses.enumerated()), id: \.offset) { index, sense in
                        VStack(alignment: .leading, spacing: 6) {
                            // 1. Definition in English
                            HStack(alignment: .top, spacing: 6) {
                                Text("\(index + 1).")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(hex: "#059669"))
                                
                                Text(sense.definition)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "#111827"))
                                    .lineSpacing(3)
                            }
                            
                            // 2. Meaning / Translation in Vietnamese (Đảm bảo có tiếng Việt để đọc hiểu)
                            let viText = service.vietnameseDefinitions[sense.definition] ?? sense.vietnameseTranslation
                            if let vi = viText, !vi.isEmpty {
                                HStack(alignment: .top, spacing: 6) {
                                    Text("→")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(hex: "#2563EB"))
                                    
                                    Text(vi)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(hex: "#0F3E36"))
                                        .lineSpacing(2)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#EFF6FF"))
                                .cornerRadius(6)
                                .padding(.leading, 18)
                            }
                            
                            // 3. Examples
                            if let examples = sense.examples, !examples.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(examples, id: \.self) { ex in
                                        HStack(alignment: .top, spacing: 6) {
                                            Text("•")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(Color(hex: "#7C3AED"))
                                            
                                            Text("\"\(ex)\"")
                                                .font(.system(size: 12, weight: .regular, design: .serif))
                                                .italic()
                                                .foregroundColor(Color(hex: "#374151"))
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                service.speak(text: ex)
                                            }) {
                                                Image(systemName: "speaker.wave.1.fill")
                                                    .font(.system(size: 11))
                                                    .foregroundColor(Color(hex: "#7C3AED"))
                                                    .padding(4)
                                            }
                                        }
                                    }
                                }
                                .padding(.leading, 18)
                                .padding(.top, 2)
                            }
                            
                            // 4. Synonyms & Antonyms for this sense
                            if let syns = sense.synonyms, !syns.isEmpty {
                                HStack(spacing: 4) {
                                    Text("Đồng nghĩa:")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color(hex: "#059669"))
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 4) {
                                            ForEach(Array(syns.prefix(5)), id: \.self) { syn in
                                                Button(action: {
                                                    searchInput = syn
                                                    performSearch()
                                                }) {
                                                    Text(syn)
                                                        .font(.system(size: 11))
                                                        .foregroundColor(Color(hex: "#065F46"))
                                                        .padding(.horizontal, 6)
                                                        .padding(.vertical, 2)
                                                        .background(Color(hex: "#ECFDF5"))
                                                        .cornerRadius(4)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.leading, 18)
                                .padding(.top, 2)
                            }
                        }
                        .padding(12)
                        .background(Color(hex: "#F9FAFB"))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
    }
    
    // MARK: - Attribution Card
    private func attributionCard(source: DictionarySource) -> some View {
        VStack(spacing: 6) {
            Text("Dữ liệu nguồn từ English Wiktionary theo giấy phép CC BY-SA 4.0.")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#9CA3AF"))
                .multilineTextAlignment(.center)
            
            if let urlStr = source.url, let url = URL(string: urlStr) {
                Link("Xem bài viết gốc trên Wiktionary", destination: url)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "#059669"))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}
