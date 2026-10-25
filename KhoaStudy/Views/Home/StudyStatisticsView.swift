import SwiftUI

/// Sơ Đồ Thống Kê Học Tập - Hiển thị 100% SỐ LIỆU THỰC TẾ
/// Lấy dữ liệu từ StudyHistoryStore (bài học thật), ExamHistoryStore (điểm thi thật) và AppState (thời gian tự học & phiên Pomodoro thật)
/// Thiết kế chuẩn hiện đại: Phẳng, thoáng, KHÔNG khung lồng khung (Single-layer clean surface)
struct StudyStatisticsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @ObservedObject private var historyStore = StudyHistoryStore.shared
    @ObservedObject private var examStore = ExamHistoryStore.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F8FAF9")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        // 1. User Header & Title
                        headerOverviewSection
                        
                        // 2. 4-Box Key Metrics Grid (Single-layer cards, flat & modern)
                        keyMetricsGrid
                        
                        // 3. Subject Distribution Breakdown (100% Real from historyStore)
                        subjectBreakdownSection
                        
                        // 4. Grade & Semester Progress (100% Real from historyStore)
                        gradeAndSemesterSection
                        
                        // 5. Exam & Practice Performance (100% Real from examStore)
                        examPerformanceSection
                        
                        // 6. Recent Learning Activity Log (100% Real)
                        recentActivityLogSection
                        
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                            Text("Trang Chủ")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.primaryDark)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Sơ Đồ Thống Kê")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
        }
    }
    
    // MARK: - 1. Header Overview
    private var headerOverviewSection: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#10B981"), Color(hex: "#059669")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("\(appState.currentUser.username) • Lớp \(appState.currentUser.grade)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "#059669"))
                
                Text("Dữ Liệu Học Tập Thực Tế")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                
                Text("Ghi nhận chính xác 100% lịch sử học, thời gian và điểm thi")
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - 2. 4-Box Key Metrics Grid (100% SỐ LIỆU THỰC TẾ)
    private var keyMetricsGrid: some View {
        let totalHours = appState.totalStudyMinutes / 60
        let totalMins = appState.totalStudyMinutes % 60
        let timeString: String
        if appState.totalStudyMinutes == 0 {
            timeString = "0 phút"
        } else if totalHours > 0 {
            timeString = "\(totalHours)h \(totalMins)p"
        } else {
            timeString = "\(totalMins) phút"
        }
        
        let lessonCount = historyStore.historyList.count
        let examCount = examStore.records.count
        
        return LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            // Metric 1: Thời gian tự học
            metricTile(
                icon: "clock.badge.checkmark.fill",
                iconColor: Color(hex: "#0284C7"),
                bgColor: Color(hex: "#E0F2FE"),
                value: timeString,
                label: "Tổng thời gian tự học"
            )
            
            // Metric 2: Bài học đã nạp
            metricTile(
                icon: "book.fill",
                iconColor: Color(hex: "#059669"),
                bgColor: Color(hex: "#D1FAE5"),
                value: "\(lessonCount) bài",
                label: "Bài học đã ghi nhận"
            )
            
            // Metric 3: Phiên Pomodoro tập trung
            metricTile(
                icon: "flame.fill",
                iconColor: Color(hex: "#EA580C"),
                bgColor: Color(hex: "#FFEDD5"),
                value: "\(appState.focusSessionCount) phiên",
                label: "Phiên treo máy học tập"
            )
            
            // Metric 4: Số đề thi đã hoàn thành
            metricTile(
                icon: "doc.text.fill",
                iconColor: Color(hex: "#7C3AED"),
                bgColor: Color(hex: "#F3E8FF"),
                value: "\(examCount) đề",
                label: "Đề thi đã làm xong"
            )
        }
    }
    
    private func metricTile(icon: String, iconColor: Color, bgColor: Color, value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Circle()
                    .fill(bgColor)
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                    .lineLimit(1)
                
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - 3. Subject Breakdown Section (100% Real from historyStore)
    private var subjectBreakdownSection: some View {
        let stats = computeRealSubjectStats()
        
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Phân Bố Kiến Thức Theo Môn")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text("Dựa trên các bài học đã mở học trong lịch sử")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Image(systemName: "circle.grid.2x2.fill")
                    .foregroundColor(Color(hex: "#10B981"))
            }
            
            if stats.isEmpty {
                // Empty state khi học sinh chưa học bài nào
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 28))
                            .foregroundColor(Color.gray.opacity(0.4))
                        Text("Chưa có bài học nào được ghi nhận")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                        Text("Hãy chọn một bài học ở mục 'Học lí thuyết' để bắt đầu")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textMuted)
                    }
                    .padding(.vertical, 16)
                    Spacer()
                }
            } else {
                // Stacked Multi-Color Progress Bar
                GeometryReader { geo in
                    HStack(spacing: 3) {
                        ForEach(stats) { item in
                            let w = max(geo.size.width * CGFloat(item.percentage) / 100.0, 8)
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(item.color)
                                .frame(width: w, height: 12)
                        }
                    }
                }
                .frame(height: 12)
                .clipShape(Capsule())
                
                // Subject Details Rows (Flat, no inner border)
                VStack(spacing: 10) {
                    ForEach(stats) { item in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 10, height: 10)
                            
                            Text(item.name)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#1F2937"))
                            
                            Spacer()
                            
                            Text("\(item.lessonCount) bài (\(Int(item.percentage))%)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 3)
        )
    }
    
    // MARK: - 4. Grade & Semester Progress (100% Real from historyStore)
    private var gradeAndSemesterSection: some View {
        let total = max(historyStore.historyList.count, 1)
        let g12 = historyStore.historyList.filter { $0.topicItem.grade == 12 }.count
        let g11 = historyStore.historyList.filter { $0.topicItem.grade == 11 }.count
        let g10 = historyStore.historyList.filter { $0.topicItem.grade == 10 }.count
        
        let sem1 = historyStore.historyList.filter { $0.topicItem.semester == 1 }.count
        let sem2 = historyStore.historyList.filter { $0.topicItem.semester == 2 }.count
        
        let hasData = !historyStore.historyList.isEmpty
        
        return VStack(alignment: .leading, spacing: 14) {
            Text("Phân Bố Khối Lớp & Học Kì")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            VStack(spacing: 12) {
                realProgressBar(title: "Lớp 12", count: g12, total: hasData ? total : 0, color: Color(hex: "#059669"))
                realProgressBar(title: "Lớp 11", count: g11, total: hasData ? total : 0, color: Color(hex: "#0284C7"))
                realProgressBar(title: "Lớp 10", count: g10, total: hasData ? total : 0, color: Color(hex: "#9333EA"))
            }
            
            Divider().padding(.vertical, 4)
            
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "1.circle.fill")
                        .foregroundColor(Color(hex: "#059669"))
                    Text("Học kì 1: \(sem1) bài (\(hasData ? Int(Double(sem1)/Double(total)*100) : 0)%)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#374151"))
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "2.circle.fill")
                        .foregroundColor(Color(hex: "#0284C7"))
                    Text("Học kì 2: \(sem2) bài (\(hasData ? Int(Double(sem2)/Double(total)*100) : 0)%)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#374151"))
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 3)
        )
    }
    
    private func realProgressBar(title: String, count: Int, total: Int, color: Color) -> some View {
        let pct = total > 0 ? Double(count) / Double(total) : 0.0
        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "#1F2937"))
                Spacer()
                Text("\(count) bài (\(Int(pct * 100))%)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(count > 0 ? color : AppTheme.textMuted)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(color.opacity(0.12))
                        .frame(height: 8)
                    
                    if count > 0 {
                        Capsule()
                            .fill(color)
                            .frame(width: max(geo.size.width * CGFloat(pct), 8), height: 8)
                    }
                }
            }
            .frame(height: 8)
        }
    }
    
    // MARK: - 5. Exam Performance (100% Real from examStore)
    private var examPerformanceSection: some View {
        let records = Array(examStore.recent5Records.reversed())
        let avg = examStore.averageScore
        
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Điểm Thi & Kết Quả Luyện Đề")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text(records.isEmpty ? "Chưa có lượt làm bài nào" : "\(records.count) bài thi gần nhất")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                
                if let avg = avg {
                    Text("ĐTB: \(String(format: "%.1f", avg)) / 10")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "#DC2626"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color(hex: "#FEE2E2")))
                } else {
                    Text("Chưa có điểm")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppTheme.textMuted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.gray.opacity(0.1)))
                }
            }
            
            if records.isEmpty {
                // Empty state thật khi chưa làm đề
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "pencil.and.outline")
                            .font(.system(size: 32))
                            .foregroundColor(Color.gray.opacity(0.4))
                        Text("Chưa có bài thi nào được thực hiện")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "#374151"))
                        Text("Vào mục 'Ôn thi bứt phá điểm cao' để làm đề thi đầu tiên. Điểm số thật của bạn sẽ được lưu và vẽ biểu đồ tại đây!")
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 14)
                    Spacer()
                }
            } else {
                // Bar Chart Visualization từ kết quả thật
                HStack(alignment: .bottom, spacing: 14) {
                    ForEach(Array(records.enumerated()), id: \.element.id) { index, rec in
                        realBarChartColumn(
                            label: rec.shortDate,
                            score: rec.score,
                            maxScore: 10.0,
                            color: rec.score >= 8.0 ? Color(hex: "#059669") : (rec.score >= 5.0 ? Color(hex: "#0284C7") : Color(hex: "#DC2626"))
                        )
                    }
                }
                .frame(height: 120)
                .padding(.top, 8)
                .padding(.horizontal, 8)
                
                Divider().padding(.vertical, 2)
                
                HStack(spacing: 16) {
                    HStack(spacing: 5) {
                        Circle().fill(Color(hex: "#059669")).frame(width: 8, height: 8)
                        Text("Giỏi (>= 8.0)")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    HStack(spacing: 5) {
                        Circle().fill(Color(hex: "#0284C7")).frame(width: 8, height: 8)
                        Text("Khá (5.0 - 7.9)")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    HStack(spacing: 5) {
                        Circle().fill(Color(hex: "#DC2626")).frame(width: 8, height: 8)
                        Text("Cần ôn thêm (< 5.0)")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 3)
        )
    }
    
    private func realBarChartColumn(label: String, score: Double, maxScore: Double, color: Color) -> some View {
        let fraction = CGFloat(max(0.1, score / maxScore))
        let barHeight = max(90 * fraction, 16)
        
        return VStack(spacing: 6) {
            Text(String(format: "%.1f", score))
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.7), color],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: barHeight)
            
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - 6. Recent Learning Activity Log (100% Real)
    private var recentActivityLogSection: some View {
        let history = Array(historyStore.historyList.prefix(5))
        
        return VStack(alignment: .leading, spacing: 14) {
            Text("Nhật Ký Học Tập Gần Đây")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            
            if history.isEmpty {
                Text("Chưa có hoạt động học nào gần đây.")
                    .font(.caption)
                    .foregroundColor(AppTheme.textMuted)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 10) {
                    ForEach(history) { item in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color(hex: "#D1FAE5"))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color(hex: "#059669"))
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.topicItem.title)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1F2937"))
                                    .lineLimit(1)
                                
                                Text("\(item.topicItem.subject) • Lớp \(item.topicItem.grade) • \(item.sectionHeader)")
                                    .font(.caption2)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 3)
        )
    }
    
    // MARK: - Helper to compute Real Subject Stats
    private struct SubjectStatItem: Identifiable {
        let id = UUID()
        let name: String
        let lessonCount: Int
        let percentage: Double
        let color: Color
    }
    
    private func computeRealSubjectStats() -> [SubjectStatItem] {
        let history = historyStore.historyList
        guard !history.isEmpty else { return [] }
        
        let subjects = [
            ("Toán", Color(hex: "#0284C7")),
            ("Vật lí", Color(hex: "#7C3AED")),
            ("Hóa học", Color(hex: "#EA580C")),
            ("Sinh học", Color(hex: "#059669")),
            ("Lịch sử", Color(hex: "#DC2626")),
            ("Địa lí", Color(hex: "#0D9488"))
        ]
        
        var counts: [String: Int] = [:]
        for item in history {
            counts[item.topicItem.subject, default: 0] += 1
        }
        
        let total = history.count
        var result: [SubjectStatItem] = []
        for (subName, col) in subjects {
            let count = counts[subName] ?? 0
            if count > 0 {
                let pct = (Double(count) / Double(total)) * 100.0
                result.append(SubjectStatItem(name: subName, lessonCount: count, percentage: pct, color: col))
            }
        }
        return result
    }
}
