import SwiftUI

/// Màn hình Lịch Sử Học Tập: Tab riêng biệt quản lý tất cả các bài lý thuyết đã mở học và ôn tập
struct StudyHistoryView: View {
    @ObservedObject private var historyStore = StudyHistoryStore.shared
    @State private var selectedTopic: TheoryTopicItem? = nil
    @State private var showingClearAlert: Bool = false
    
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
                .padding(.bottom, 74)
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
