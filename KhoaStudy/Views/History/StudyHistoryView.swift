import SwiftUI

/// Màn hình Lịch Sử Học Tập: Tab riêng biệt quản lý tất cả các bài lý thuyết đã mở học và ôn tập
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
                    // Top Navigation Bar
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
    
    // MARK: - Top Navigation Bar
    private var topNavBar: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                if let onClose = onClose {
                    Button(action: {
                        onClose()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                            Text("Trang Chủ")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.primaryDark)
                    }
                    .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Lịch Sử Học Tập")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    
                    Text("\(historyStore.historyList.count) bài học lý thuyết đã lưu")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                if !historyStore.historyList.isEmpty {
                    Button(action: {
                        showingClearAlert = true
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                            Text("Xóa hết")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(Color(hex: "#EF4444"))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 14)
            .background(Color.white)
            
            Divider()
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 18) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#E0F2FE"), Color(hex: "#BAE6FD")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(Color(hex: "#0284C7"))
            }
            
            Text("Chưa có lịch sử học tập")
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            Text("Khi bạn mở bài học lý thuyết chuẩn SGK, hệ thống sẽ tự động ghi nhớ tại đây để bạn có thể xem lại và ôn tập bất cứ lúc nào.")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
    
    // MARK: - History Content List
    private var historyContentList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(historyStore.groupedSections, id: \.sectionTitle) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        // Section Header: -- HÔM NAY --, -- HÔM QUA --
                        Text("-- \(group.sectionTitle.uppercased()) --")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 6)
                        
                        VStack(spacing: 8) {
                            ForEach(group.items) { item in
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
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 140)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }
}

// MARK: - Swipeable History Row (Vuốt Trái Để Xóa Chuẩn iOS)
struct SwipeableHistoryRow: View {
    let item: StudyHistoryItem
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isSwiped: Bool = false
    
    private let buttonWidth: CGFloat = 72
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Nút Xóa đỏ nằm phía dưới bên phải
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        onDelete()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16, weight: .bold))
                        Text("Xóa")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(width: buttonWidth)
                    .frame(maxHeight: .infinity)
                    .background(Color(hex: "#EF4444"))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            
            // Thẻ nội dung chính
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(hex: "#ECFDF5"))
                            .frame(width: 38, height: 38)
                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppTheme.primaryMint)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.topicItem.title)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text("Lớp \(item.topicItem.grade) - Học Kì \(item.topicItem.semester) - Môn: \(item.topicItem.subject)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray.opacity(0.4))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 1)
                )
            }
            .buttonStyle(.plain)
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 15)
                    .onChanged { value in
                        if value.translation.width < 0 {
                            // Vuốt sang trái
                            let drag = value.translation.width + (isSwiped ? -buttonWidth : 0)
                            offset = max(-buttonWidth - 15, drag)
                        } else if isSwiped && value.translation.width > 0 {
                            // Kéo ngược lại về phải
                            offset = min(0, -buttonWidth + value.translation.width)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            if value.translation.width < -30 {
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
    }
}
