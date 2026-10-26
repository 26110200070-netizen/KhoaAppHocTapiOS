import SwiftUI
import AVFoundation

struct EnglishWordDetailSheet: View {
    let word: EnglishWord
    var onDismiss: () -> Void
    
    @State private var isSpeaking: Bool = false
    @State private var speakingExampleIndex: Int? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background
            Color(hex: "#F9FAFB")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Drag indicator & header
                topBarHeader
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // 1. Primary Word Card
                        wordHeroCard
                        
                        // 2. Collocations Section
                        if !word.collocations.isEmpty {
                            collocationsSection
                        }
                        
                        // 3. Examples Section
                        if !word.examples.isEmpty {
                            examplesSection
                        }
                        
                        // 4. Learning Tips Card
                        learningTipCard
                        
                        Spacer().frame(height: 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                }
            }
        }
    }
    
    // MARK: - Top Bar Header
    private var topBarHeader: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: word.category.icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "#059669"))
                
                Text(word.category.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "#059669"))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color(hex: "#ECFDF5"))
            .clipShape(Capsule())
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    // MARK: - Word Hero Card
    private var wordHeroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(word.word)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                        
                        // CEFR Level Badge
                        Text(word.level.rawValue)
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: word.level.badgeColorHex))
                            .clipShape(Capsule())
                    }
                    
                    // Phonetic & Audio Speak Button
                    HStack(spacing: 8) {
                        Text(word.phonetic)
                            .font(.system(size: 17, weight: .medium, design: .serif))
                            .foregroundColor(Color(hex: "#4B5563"))
                        
                        Button(action: {
                            EnglishVocabularyStore.shared.speak(text: word.word)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 13, weight: .bold))
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
                
                // Part of Speech tag
                Text(word.partOfSpeech)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#F3F4F6"))
                    .cornerRadius(8)
            }
            
            Divider()
                .background(Color(hex: "#E5E7EB"))
            
            // Meaning in Vietnamese
            VStack(alignment: .leading, spacing: 4) {
                Text("NGHĨA TIẾNG VIỆT")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                
                Text(word.meaningVI)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "#0F3E36"))
                    .lineSpacing(4)
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
    }
    
    // MARK: - Collocations Section
    private var collocationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "link")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#2563EB"))
                
                Text("Cụm từ hay gặp (Collocations)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "#1F2937"))
            }
            
            FlowLayout(spacing: 8) {
                ForEach(word.collocations, id: \.self) { collocation in
                    Button(action: {
                        EnglishVocabularyStore.shared.speak(text: collocation)
                    }) {
                        HStack(spacing: 5) {
                            Text(collocation)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(hex: "#1E40AF"))
                            
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "#3B82F6"))
                        }
                        .padding(.horizontal, 11)
                        .padding(.vertical, 7)
                        .background(Color(hex: "#EFF6FF"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "#DBEAFE"), lineWidth: 1)
                        )
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - Examples Section
    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "text.quote")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#7C3AED"))
                
                Text("Ví dụ ngữ cảnh thực tế")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "#1F2937"))
            }
            
            VStack(spacing: 12) {
                ForEach(Array(word.examples.enumerated()), id: \.offset) { index, ex in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top) {
                            Text(ex.sentenceEN)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(hex: "#111827"))
                                .lineSpacing(3)
                            
                            Spacer()
                            
                            Button(action: {
                                speakingExampleIndex = index
                                EnglishVocabularyStore.shared.speak(text: ex.sentenceEN)
                            }) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "#7C3AED"))
                                    .padding(7)
                                    .background(Color(hex: "#F5F3FF"))
                                    .clipShape(Circle())
                            }
                        }
                        
                        Text(ex.sentenceVI)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(hex: "#6B7280"))
                            .lineSpacing(2)
                    }
                    .padding(14)
                    .background(Color(hex: "#F9FAFB"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#F3F4F6"), lineWidth: 1)
                    )
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    // MARK: - Learning Tip Card
    private var learningTipCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "#D97706"))
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Mẹo ghi nhớ từ Shimy AI")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "#92400E"))
                
                Text("Hãy đặt câu với từ '\(word.word)' trong nhật ký hoặc thử phát âm lại 3 lần để khắc sâu trí nhớ dài hạn.")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(hex: "#B45309"))
                    .lineSpacing(2)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "#FEF3C7").opacity(0.6))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "#FDE68A"), lineWidth: 1)
        )
    }
}

// MARK: - Flow Layout for Collocation Tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var maxHeightInRow: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                x = 0
                y += maxHeightInRow + spacing
                maxHeightInRow = 0
            }
            maxHeightInRow = max(maxHeightInRow, size.height)
            x += size.width + spacing
        }
        height = y + maxHeightInRow
        return CGSize(width: width, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var maxHeightInRow: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX
                y += maxHeightInRow + spacing
                maxHeightInRow = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            maxHeightInRow = max(maxHeightInRow, size.height)
            x += size.width + spacing
        }
    }
}
