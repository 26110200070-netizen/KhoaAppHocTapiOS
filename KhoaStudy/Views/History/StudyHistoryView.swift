import SwiftUI

/// Màn hình Lịch Sử Học Tập: Thiết kế tối giản, kỹ thuật cao, không khung lồng chữ
struct StudyHistoryView: View {
    @ObservedObject private var historyStore = StudyHistoryStore.shared
    @State private var selectedTopic: TheoryTopicItem? = nil
    @State private var showingClearAlert: Bool = false
    var onClose: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color(hex: "#F9FAFB").ignoresSafeArea()
            
            if let topic = selectedTopic {
                TheoryLessonDetailView(topicItem: topic, onBack: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedTopic = nil
                    }
                })
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                .zIndex(2)
            } else {
                VStack(spacing: 0) {
                    topNavBar
                    
                    if historyStore.historyList.isEmpty {
                        emptyStateView
                    } else {
                        historyContentList
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        }
        .alert(isPresented: $showingClearAlert) {
            Alert(
                title: Text("Xóa toàn bộ lịch sử"),
                message: Text("Bạn có chắc chắn muốn xóa toàn bộ danh sách bài học đã lưu? Hành động này không thể hoàn tác."),
                primaryButton: .destructive(Text("Xóa hết")) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        historyStore.historyList.removeAll()
                        UserDefaults.standard.removeObject(forKey: "shimy_study_history_v1")
                    }
                },
                secondaryButton: .cancel(Text("Hủy"))
            )
        }
    }
    
    // MARK: - Top Navigation Bar (Flat, clean, quiet)
    private var topNavBar: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                if let onClose = onClose {
                    Button(action: { onClose() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                            Text("Trang Chủ")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.primaryDark)
                    }
                    .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Lịch Sử Học Tập")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    Text("\(historyStore.historyList.count) bài học lý thuyết đã mở")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#6B7280"))
                }
                
                Spacer()
                
                if !historyStore.historyList.isEmpty {
                    Button(action: { showingClearAlert = true }) {
                        Text("Xóa hết")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "#EF4444"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 12)
            .background(Color.white)
            
            Divider()
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Circle()
                .fill(Color(hex: "#F3F4F6"))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(Color(hex: "#6B7280"))
                )
            
            VStack(spacing: 6) {
                Text("Chưa có lịch sử học tập")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("Các bài học lý thuyết bạn đã mở sẽ tự động lưu trữ tại đây để ôn tập nhanh chóng bất kỳ lúc nào.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 36)
            }
            
            Spacer()
            Spacer()
        }
    }
    
    // MARK: - Grouped History Content List (Single-surface grouped card, no nested box)
    private var historyContentList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 18) {
                ForEach(historyStore.groupedSections, id: \.sectionTitle) { group in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(group.sectionTitle.uppercased())
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#6B7280"))
                            .padding(.leading, 8)
                        
                        VStack(spacing: 0) {
                            ForEach(Array(group.items.enumerated()), id: \.element.id) { index, item in
                                SwipeableHistoryRow(
                                    item: item,
                                    onSelect: {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            selectedTopic = item.topicItem
                                        }
                                    },
                                    onDelete: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            historyStore.remove(id: item.id)
                                        }
                                    }
                                )
                                
                                if index < group.items.count - 1 {
                                    Divider()
                                        .padding(.leading, 20)
                                }
                            }
                        }
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                        )
                    }
                }
                
                Spacer().frame(height: 120)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
        }
    }
}

// MARK: - Clean Single-Layer Row
struct SwipeableHistoryRow: View {
    let item: StudyHistoryItem
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isSwiped: Bool = false
    
    private let buttonWidth: CGFloat = 68
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        onDelete()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "trash")
                            .font(.system(size: 15, weight: .bold))
                        Text("Xóa")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(width: buttonWidth)
                    .frame(maxHeight: .infinity)
                    .background(Color(hex: "#EF4444"))
                }
            }
            
            Button(action: {
                if isSwiped {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        offset = 0
                        isSwiped = false
                    }
                } else {
                    onSelect()
                }
            }) {
                HStack(spacing: 12) {
                    // Vertical subject accent strip
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(subjectColor(for: item.topicItem.subject))
                        .frame(width: 3.5, height: 42)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Clean metadata typography breadcrumb
                        Text("\(item.topicItem.subject.uppercased()) • LỚP \(item.topicItem.grade) • HỌC KỲ \(item.topicItem.semester)")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(subjectColor(for: item.topicItem.subject))
                        
                        Text(item.topicItem.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(Color.white)
            }
            .buttonStyle(.plain)
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 15)
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = max(-buttonWidth - 10, value.translation.width + (isSwiped ? -buttonWidth : 0))
                        } else if isSwiped && value.translation.width > 0 {
                            offset = min(0, -buttonWidth + value.translation.width)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            if value.translation.width < -25 {
                                offset = -buttonWidth
                                isSwiped = true
                            } else {
                                offset = 0
                                isSwiped = false
                            }
                        }
                    }
            )
        }
        .clipped()
    }
    
    private func subjectColor(for subject: String) -> Color {
        switch subject.lowercased() {
        case "toán": return Color(hex: "#059669")
        case "vật lí", "vật lý": return Color(hex: "#7C3AED")
        case "hóa học": return Color(hex: "#EA580C")
        case "sinh học": return Color(hex: "#10B981")
        case "lịch sử": return Color(hex: "#DC2626")
        case "địa lí", "địa lý": return Color(hex: "#0D9488")
        default: return Color(hex: "#2563EB")
        }
    }
}
